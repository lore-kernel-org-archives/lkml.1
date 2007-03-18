Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXCRSti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXCRSti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbXCRSth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:49:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34367 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932878AbXCRStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:49:23 -0400
Date: Sun, 18 Mar 2007 19:49:26 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [5/6] 2.6.21-rc4: known regressions
Message-ID: <20070318184926.GY752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : Dynticks and High resolution Timer hanging the system
             workaround: clocksource=acpi_pm
References : http://lkml.org/lkml/2007/3/7/504
Submitter  : Stephane Casset <sept@logidee.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
Status     : unknown


Subject    : soft lockup detected on CPU#0
References : http://lkml.org/lkml/2007/3/3/152
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : i386: APIC timer disabled due to verification failure
             (once in three boots or so)
References : http://lkml.org/lkml/2007/3/16/126
Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Patch      : http://lkml.org/lkml/2007/3/16/420
Status     : patch available


