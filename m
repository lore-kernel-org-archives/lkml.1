Return-Path: <linux-kernel-owner+w=401wt.eu-S1764970AbXIKVO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764970AbXIKVO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbXIKVOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:14:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55465 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759149AbXIKVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:14:18 -0400
Date: Tue, 11 Sep 2007 23:14:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070911211422.GU3563@stusta.de>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200709112138.11247.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 09:38:10PM +0100, Andi Kleen wrote:
>...
> In the end it won't make much difference where the files are located
> (although I frankly don't see the advantage of this intrusive move).
> 
> You always have to at least compile test both if you change one and I doubt 
> most  people will be able to avoid this no matter how the Makefile looks
> or where the files are. 
>...

The important point is:

People do not expect code under arch/i386/ to be used by code under 
arch/x86_64/ and vice versa.

That regularly results in people sending patches that don't compile on 
the other architecture.

With one architecture it's much more obvious that the code is shared.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

