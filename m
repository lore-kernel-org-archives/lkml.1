Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZKQWnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZKQWnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZKQWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:43:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbZKQWnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:43:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Date: Tue, 17 Nov 2009 23:44:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.CnG.JTdALB@chimera> <4B01F0F8.4040807@gmail.com>
In-Reply-To: <4B01F0F8.4040807@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172344.45338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> > Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2009-10-23 16:45 (25 days old)
> > References	: http://lkml.org/lkml/2009/10/23/252
> >
> >
> >
> >    
> This one has me a bit dazed i.g. after looking into the issue
> I did find a workaround(keep in mind it's not pretty),
> by commenting out set_fixmap_nocache and
> init_ohci1394_reset_and_init_dma.
> (by doing so I was able to load both machines and
> execute early debugging in case  a problem occurs).
> 
> Now as to what might  be happening, after going through as
> much as I can comprehend the only thing in mind was
> reading fixmap.h the comments are stating that vsyscalls
> only covers 32bit, and that there needs to be another set
> for 64, leading me to believe that this is what I might be hitting.
> (my system is pure64, taking in no 32bit at all).
> 
> At this point I think I need somebody to give me some info on this,
> and if the 64bit issue mentioned above is the case, then we can probably
> close this and leave it up to the x86_64 builders to create a 64bit
> call for this whenever they get to it.(main thing is I'm able to
> run dma early in case of an emergency).

Thanks for the update.

Rafael
