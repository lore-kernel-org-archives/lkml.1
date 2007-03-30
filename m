Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXC3Vcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXC3Vcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXC3Vcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:32:48 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38924 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932185AbXC3VcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:32:21 -0400
Date: Fri, 30 Mar 2007 23:32:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Soeren Sonnenburg <kernel@nn7.de>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Marcus Better <marcus@better.se>, adaplas@gmail.com,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Mike Harris <atarimike@wavecable.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
       tigran@aivazian.fsnet.co.uk
Subject: [3/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070330213220.GO14134@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : ThinkPad X60: resume no longer works  (PCI related?)
References : http://lkml.org/lkml/2007/3/13/3
Submitter  : Dave Jones <davej@redhat.com>
             Jeremy Fitzhardinge <jeremy@goop.org>
Caused-By  : PCI merge
             commit 78149df6d565c36675463352d0bfe0000b02b7a7
Handled-By : Eric W. Biederman <ebiederm@xmission.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : problem is being debugged


Subject    : Suspend to RAM doesn't work anymore  (ACPI?)
References : http://lkml.org/lkml/2007/3/19/128
             http://bugzilla.kernel.org/show_bug.cgi?id=8247
Submitter  : Tobias Doerffel <tobias.doerffel@gmail.com>
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
             Len Brown <len.brown@intel.com>
Status     : problem is being debugged


Subject    : SATA breakage on resume
References : http://lkml.org/lkml/2007/3/7/233
Submitter  : Thomas Gleixner <tglx@linutronix.de>
             Soeren Sonnenburg <kernel@nn7.de>
Status     : unknown


Subject    : resume from RAM corrupts vesafb console
References : http://lkml.org/lkml/2007/3/26/76
Submitter  : Marcus Better <marcus@better.se>
Handled-By : Pavel Machek <pavel@ucw.cz>
Status     : problem is being debugged


Subject    : ThinkPad doesn't resume from suspend to RAM
References : http://lkml.org/lkml/2007/2/27/80
             http://lkml.org/lkml/2007/2/28/348
Submitter  : Jens Axboe <jens.axboe@oracle.com>
             Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


Subject    : MacBook Core Duo: suspend to memory wakeup hang
References : http://bugzilla.kernel.org/show_bug.cgi?id=8272
Submitter  : Mike Harris <atarimike@wavecable.com>
Status     : unknown


Subject    : suspend to disk hangs  (skge)
References : http://lkml.org/lkml/2007/3/27/212
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Caused-By  : Stephen Hemminger <shemminger@linux-foundation.org>
             commit a504e64ab42bcc27074ea37405d06833ed6e0820
Status     : unknown


Subject    : suspend to disk hangs  (microcode driver)
References : http://lkml.org/lkml/2007/3/16/126
Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
             commit e3c7db621bed4afb8e231cb005057f2feb5db557
             commit ed746e3b18f4df18afa3763155972c5835f284c5
             commit 259130526c267550bc365d3015917d90667732f1
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Patch      : http://lkml.org/lkml/2007/3/25/71
Status     : patch available

