Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbXLGRsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbXLGRsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXLGRsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:48:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40093 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753727AbXLGRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:48:47 -0500
Date: Fri, 7 Dec 2007 18:48:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
Message-ID: <20071207174843.GA20441@stusta.de>
References: <47555AF1.8090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47555AF1.8090304@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 10:49:37PM +0900, Tejun Heo wrote:
> When multiple built-in modules (especially drivers) provide the same
> capability, they're prioritized by link order specified by the order
> listed in Makefile.  This implicit ordering is lost for loadable
> modules.
>...

What exactly are the drivers you are thinking of?

I would rather see us getting away from any link order dependencies.

E.g. we might one day want to compile the whole kernel with one gcc call 
(using "--combine -fwhole-program").

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

