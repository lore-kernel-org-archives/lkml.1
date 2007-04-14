Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbXDNAiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbXDNAiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXDNAiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:38:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49960 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbXDNAiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:38:02 -0400
Date: Sat, 14 Apr 2007 02:38:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Dave Jones <davej@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Marcus Better <marcus@better.se>, adaplas@gmail.com,
       James Simmons <jsimmons@infradead.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [3/3] 2.6.21-rc6: known regressions
Message-ID: <20070414003808.GU5907@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : suspend to disk works only once
References : http://lkml.org/lkml/2007/4/13/240
Submitter  : Tobias Diedrich <ranma+kernel@tdiedrich.de>
Status     : unknown


Subject    : ThinkPad X60: resume no longer works  (PCI related?)
             workaround: booting with "hpet=disable"
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


Subject    : resume from RAM corrupts vesafb console
References : http://lkml.org/lkml/2007/3/26/76
Submitter  : Marcus Better <marcus@better.se>
Handled-By : Pavel Machek <pavel@ucw.cz>
Status     : problem is being debugged


Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/3/25/217
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown

