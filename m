Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXBXRy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXBXRy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbXBXRy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 12:54:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:54544 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932437AbXBXRyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 12:54:25 -0500
Cc: akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 24 Feb 2007 18:54:24 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070224175424.176030@gmx.net>
MIME-Version: 1.0
Subject: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be
 mounted without hanging up the whole system
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+6nXl2OrW63cS696DPkDCWuGqbMs8Z0hLC4YfxiS
 R+/7u5XVy/kBczYPkuA1BDVCY= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
Second attempt now:
I already reported to Linus Torvalds and Andrew Morton that it is impossible to mount a conventional floppy drive without hanging up the whole system.
Andrew's reaction was quite ambiguous: "We did not break it"

Once again and for the last time: I do not state that floppy.c is broken. I only state that it is immpossible to mount a floppy drive with kernel 2.6.21-rc1-git1. Kernel 2.6.20 is OK. But 2.6.21-rc1-git1 is definitely buggy!
I did some work already:
a. I copied the following modules from the intact and sane kernel 2.6.20 into the 2.6.21-rc1-git1 tree:
cdrom.h, floppy.c, init.h, io.h, proc_misc.c, setup.c, timer.h, uaccess.h
b. I adjusted some hunks of the patch for module main.c (part of patch-2.6.21-rc1) to make the kernel compile without errors.
But the problem still persists, and I do not have any idea anymore where the offensive hunks in patch-2.6.21-rc1 could reside.

Questions:
a. Can someone please confirm the described problem?
b. Can someone please take action to find out where the buggy code resides?
c. Why is this untested material being pushed into main vanilla - what is going on at kernel.org please?

Please take action! The bug was introduced somewhere at the transition of 2.6.20 towards 2.6.20-git14.

Yours sincerely

Uwe

P. S.: I once again repeat my proposal: Every patch code should be tested before it is being pushed into main vanilla.
The testing tree is the mm-tree.
If this policy producing regressions persists noone takes advantage of! So please avoid those regressions in future!
If this rule "test your changes, however small, on at least 4 or 5 people" does not apply to absolutely everybody then it is worth nothing!
My platform is i386, Intel ICH4 and I am using floppy.c (Normal floppy disk support).

-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
