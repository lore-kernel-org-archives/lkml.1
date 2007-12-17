Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXLQMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXLQMk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXLQMkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:40:19 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40274 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754166AbXLQMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:40:17 -0500
Date: Mon, 17 Dec 2007 13:40:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071217124023.GB30389@stusta.de>
References: <20071213222044.GH21616@stusta.de> <20071213235432.GA26669@fattire.cabal.ca> <p73tzmmf72u.fsf@bingen.suse.de> <20071217023339.ce3da56c.akpm@linux-foundation.org> <20071217121556.GA31999@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071217121556.GA31999@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 01:15:56PM +0100, Andi Kleen wrote:
> > So...  once we've moved all read-mostly variables into __read_mostly, what
> > is left behind in bss?
> 
> I had already covered that in the next paragraph which you conveniently
> snipped :)
> 
> Anyways I suspect the right solution for that would be more classes
> of variables for even better grouping.
>...

Is there any way to tell gcc that it's still allowed to omit the 
variable when it's able to prove it's read-only?

My basic fear with all the __read_mostly, immediate values,... stuff is 
that it might interfere with gcc optimizations.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

