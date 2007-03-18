Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXCRStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXCRStp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCRStl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:49:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34340 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932879AbXCRStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:49:20 -0400
Date: Sun, 18 Mar 2007 19:49:19 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Mike Harris <atarimike@wavecable.com>, Marcus Better <marcus@better.se>,
       Ray Lee <ray-lk@madrabbit.org>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Thomas Meyer <thomas@m3y3r.de>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: [3/6] 2.6.21-rc4: known regressions
Message-ID: <20070318184919.GW752@stusta.de>
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


Subject    : ThinkPad X60: resume no longer works  (PCI related?)
References : http://lkml.org/lkml/2007/3/13/3
Submitter  : Dave Jones <davej@redhat.com>
             Jeremy Fitzhardinge <jeremy@goop.org>
Caused-By  : PCI merge
             commit 78149df6d565c36675463352d0bfe0000b02b7a7
Handled-By : Eric W. Biederman <ebiederm@xmission.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : problem is being debugged


Subject    : ThinkPad doesn't resume from suspend to RAM
References : http://lkml.org/lkml/2007/2/27/80
             http://lkml.org/lkml/2007/2/28/348
Submitter  : Jens Axboe <jens.axboe@oracle.com>
             Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


Subject    : suspend to disk hangs
References : http://lkml.org/lkml/2007/3/6/142
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


Subject    : suspend to disk hangs
References : http://lkml.org/lkml/2007/3/16/126
Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
Status     : unknown


Subject    : suspend to disk hangs
References : http://bugzilla.kernel.org/show_bug.cgi?id=8224
Submitter  : Mike Harris <atarimike@wavecable.com>
Status     : unknown


Subject    : ThinkPad R60: suspend broken
References : http://lkml.org/lkml/2007/3/16/57
Submitter  : Marcus Better <marcus@better.se>
Status     : unknown


Subject    : laptop immediately resumes after suspend
References : http://lkml.org/lkml/2007/3/8/469
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Caused-By  : Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
             commit ed41dab90eb40ac4911e60406bc653661f0e4ce1
Handled-By : Len Brown <lenb@kernel.org>
Patch      : http://lkml.org/lkml/2007/3/12/228
Status     : patch available


Subject    : second suspend to disk in a row results in an oops  (libata?)
References : http://lkml.org/lkml/2007/3/17/43
Submitter  : Thomas Meyer <thomas@m3y3r.de>
Status     : unknown


Subject    : SATA breakage on resume
References : http://lkml.org/lkml/2007/3/7/233
Submitter  : Thomas Gleixner <tglx@linutronix.de>
             Soeren Sonnenburg <kernel@nn7.de>
Status     : unknown
