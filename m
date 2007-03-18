Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXCRT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXCRT7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXCRT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:59:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:25196 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbXCRT7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=F7IwFZLGNLQVR4c1HE9X8Vm9PVFnQSBvDVYNH9s9eaZgnkGLXO9eqaxoK2QdTJl3o7CVaqinaUNXSv80q/2N7Kv4j7tUOwppC5IMatTHPR7CAPbbHN912FEiVYi7+DJp1vmBGtTbTira4Dh2PgACnlQNDQoUp5njE2+PP/VUuVM=
From: Maxim <maximlevitsky@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [5/6] 2.6.21-rc4: known regressions
Date: Sun, 18 Mar 2007 21:59:42 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703182107.01894.maximlevitsky@gmail.com> <20070318192219.GA752@stusta.de>
In-Reply-To: <20070318192219.GA752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703182159.42628.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 March 2007 21:22:19 Adrian Bunk wrote:
> On Sun, Mar 18, 2007 at 09:07:01PM +0200, Maxim wrote:
> > > Subject    : i386: APIC timer disabled due to verification failure
> > >              (once in three boots or so)
> > > References : http://lkml.org/lkml/2007/3/16/126
> > > Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> > > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > > Patch      : http://lkml.org/lkml/2007/3/16/420
> > > Status     : patch available
> > 
> > Hello,
> > 
> > This one is a small issue, I got bigger ones: as I said change in code order in suspend code broke both suspend to ram and disk
> > 
> > Those are commits.
> >         e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c (breaks  S3)
> >         ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c (breaks swsusp, I don't use it, but I tested it)
> >         259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c (breaks uswsusp, that I use)
> > 
> > System freezes before suspend with those commits, even before suspend to disk.
> 
> This was in my list as
> 
> Subject    : suspend to disk hangs
> References : http://lkml.org/lkml/2007/3/16/126
> Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> Status     : unknown
> 
> But I should add your bisecting information there.
> 
> > I think that is is not so good idea to tell about all bugs in single letter ;-)

You didn't understand me, I wanted to say that I sent a email with subject line 
"[BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far"

And I think now that I did wrong that I put all regressions and bugs I found here, but not in separate emails
Anyway it is not a problem

And by the way suspend to ram also hangs and hangs before suspend (Disk powers down, screen too, but fans are on, and etc...)
Reverting those fixes it.

> 
> These were 6 emails.
> 
> And they should give an overview as complete as possible of all 
> currently known regressions.
> 
> > Regards,
> > 	Maxim Levitsky
> 
> cu
> Adrian
> 


