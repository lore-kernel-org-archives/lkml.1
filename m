Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbXDPAhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbXDPAhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXDPAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:37:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51645 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754223AbXDPAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:37:16 -0400
Date: Mon, 16 Apr 2007 02:37:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       David Brownell <david-b@pacbell.net>, Marcus Better <marcus@better.se>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>
Subject: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070416003723.GM3691@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/3/25/217
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
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
Status     : unknown


Subject    : suspend to disk works only once
References : http://lkml.org/lkml/2007/4/13/240
Submitter  : Tobias Diedrich <ranma+kernel@tdiedrich.de>
Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
             commit ed746e3b18f4df18afa3763155972c5835f284c5
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
             Dmitry Torokhov <dtor@insightbb.com>
             David Brownell <david-b@pacbell.net>
Status     : problem is being debugged


Subject    : resume from RAM corrupts vesafb console
References : http://lkml.org/lkml/2007/3/26/76
             http://lkml.org/lkml/2007/4/13/313
Submitter  : Marcus Better <marcus@better.se>
Handled-By : Pavel Machek <pavel@ucw.cz>
             Antonino A. Daplas <adaplas@gmail.com>
Status     : problem is being debugged

