Return-Path: <linux-kernel-owner+w=401wt.eu-S1750813AbXBXS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750813AbXBXS3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 13:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXBXS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 13:29:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:56508 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750813AbXBXS3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 13:29:14 -0500
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 24 Feb 2007 19:29:12 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <20070224100729.8675b425.akpm@linux-foundation.org>
Message-ID: <20070224182912.318030@gmx.net>
MIME-Version: 1.0
References: <20070224175424.176030@gmx.net>
 <20070224100729.8675b425.akpm@linux-foundation.org>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be
 mounted without hanging up the whole system
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/DF90pN5bDX0miV/D5r0AEhJfHoDW6H6HSfdFIDw
 o4Av3wThnjnPtJ8g4IOIfxJ0U= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Sat, 24 Feb 2007 10:07:29 -0800
Von: Andrew Morton <akpm@linux-foundation.org>
An: "Uwe Bugla" <uwe.bugla@gmx.de>
CC: torvalds@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org
Betreff: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system

> > On Sat, 24 Feb 2007 18:54:24 +0100 "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> > Hi folks,
> > Second attempt now:
> > I already reported to Linus Torvalds and Andrew Morton that it is
> impossible to mount a conventional floppy drive without hanging up the whole
> system.
> > Andrew's reaction was quite ambiguous: "We did not break it"
> 
> Sorry, what I meant was "Neither Linus nor I broke it".  ie: please report
> this in a place where the person who did break it can see it.  This you
> have
> done.
OK, accepted - sorry!
> 
> > Once again and for the last time: I do not state that floppy.c is
> broken. I only state that it is immpossible to mount a floppy drive with kernel
> 2.6.21-rc1-git1. Kernel 2.6.20 is OK. But 2.6.21-rc1-git1 is definitely
> buggy!
> > I did some work already:
> > a. I copied the following modules from the intact and sane kernel 2.6.20
> into the 2.6.21-rc1-git1 tree:
> > cdrom.h, floppy.c, init.h, io.h, proc_misc.c, setup.c, timer.h,
> uaccess.h
> > b. I adjusted some hunks of the patch for module main.c (part of
> patch-2.6.21-rc1) to make the kernel compile without errors.
> > But the problem still persists, and I do not have any idea anymore where
> the offensive hunks in patch-2.6.21-rc1 could reside.
> > 
> > Questions:
> > a. Can someone please confirm the described problem?
> > b. Can someone please take action to find out where the buggy code
> resides?
> > c. Why is this untested material being pushed into main vanilla - what
> is going on at kernel.org please?
> > 
> > Please take action! The bug was introduced somewhere at the transition
> of 2.6.20 towards 2.6.20-git14.
> > 
> 
> I think we'll find that it works OK for hundreds of other people, so it
> got
> broken in some manner which is specific to a very small number of
> machines,
> of which yours is one.
> 
> If that theory proves to be correct, I'm afraid that the most proactical
> way of fixing this is to ask you to run a git-bisect to find the changeset
> which introduced the regression.
Guess this theory is wrong but lets wait and see to prove who is right!
> 
OK, Andrew,
Problem: I do not have internet at home, I am sitting in a friends flat now.
So you cannot expect me to download all git patches of 2.6.20 to test.
Could you please explain the procedure of bisecting?
Above that I've spent hours to find out the essence of the problem and I am really beat to the bone!
And my linuxtv patches should be ported into kernel please, with or without Abraham, with or without Chehab. I swear you that they are OK and not buggy at all.
It is the wrong policy to execute protectionism on people having lots of administration power but in reality lacking the experience, who are not able to tolerate justified criticism.
I enjoyed Gerd and I enjoyed most of all german guys of the convergence crew. Those were real fine and honest people, especially Gerd himself.

Sincerely

Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
