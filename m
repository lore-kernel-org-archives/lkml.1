Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXDWVtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXDWVtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbXDWVtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:49:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60333 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754276AbXDWVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:48:58 -0400
Date: Mon, 23 Apr 2007 23:49:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       ak@suse.de, discuss@x86-64.org, Jeff Chua <jeff.chua.linux@gmail.com>,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>
Subject: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070423214909.GD3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : HPET enabled freeze my machine at boot
             workaround: clocksource=acpi_pm
References : http://lkml.org/lkml/2007/4/19/370
Submitter  : Guilherme Schroeder <guilherme@centralinf.com.br>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit 5d8b34fdcb384161552d01ee8f34af5ff11f9684
Handled-By : John Stultz <johnstul@us.ibm.com>
Status     : problem is being debugged


Subject    : acpi_pm clocksource loses time on x86-64
References : http://lkml.org/lkml/2007/4/17/143
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : John Stultz <johnstul@us.ibm.com>
Status     : problem is being debugged


Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/3/25/217
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


Subject    : ThinkPad X60: resume no longer works  (PCI related?)
             workaround: CONFIG_FB_BACKLIGHT=n
References : http://lkml.org/lkml/2007/3/13/3
Submitter  : Dave Jones <davej@redhat.com>
Caused-By  : PCI merge
             commit 78149df6d565c36675463352d0bfe0000b02b7a7
Handled-By : Eric W. Biederman <ebiederm@xmission.com>
             Rafael J. Wysocki <rjw@sisk.pl>
             Antonino A. Daplas <adaplas@gmail.com>
Status     : unknown


Subject    : suspend to disk works only once
             workaround: "echo shutdown > /sys/power/disk"
References : http://lkml.org/lkml/2007/4/13/240
Submitter  : Tobias Diedrich <ranma+kernel@tdiedrich.de>
Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
             commit ed746e3b18f4df18afa3763155972c5835f284c5
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
             Dmitry Torokhov <dtor@insightbb.com>
Status     : problem is being debugged


