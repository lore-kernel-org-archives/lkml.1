Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXCRTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXCRTWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXCRTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:22:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34413 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753278AbXCRTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:22:20 -0400
Date: Sun, 18 Mar 2007 20:22:19 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Maxim <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
Subject: Re: [5/6] 2.6.21-rc4: known regressions
Message-ID: <20070318192219.GA752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184926.GY752@stusta.de> <200703182107.01894.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703182107.01894.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 09:07:01PM +0200, Maxim wrote:
> > Subject    : i386: APIC timer disabled due to verification failure
> >              (once in three boots or so)
> > References : http://lkml.org/lkml/2007/3/16/126
> > Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Patch      : http://lkml.org/lkml/2007/3/16/420
> > Status     : patch available
> 
> Hello,
> 
> This one is a small issue, I got bigger ones: as I said change in code order in suspend code broke both suspend to ram and disk
> 
> Those are commits.
>         e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c (breaks  S3)
>         ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c (breaks swsusp, I don't use it, but I tested it)
>         259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c (breaks uswsusp, that I use)
> 
> System freezes before suspend with those commits, even before suspend to disk.

This was in my list as

Subject    : suspend to disk hangs
References : http://lkml.org/lkml/2007/3/16/126
Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
Status     : unknown

But I should add your bisecting information there.

> I think that is is not so good idea to tell about all bugs in single letter ;-)

These were 6 emails.

And they should give an overview as complete as possible of all 
currently known regressions.

> Regards,
> 	Maxim Levitsky

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

