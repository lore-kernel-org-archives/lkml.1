Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXCEBxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXCEBxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXCEBwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:52:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49994 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808AbXCEBud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:50:33 -0500
Date: Mon, 5 Mar 2007 02:50:34 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net, Thomas Meyer <thomas.mey@web.de>,
       Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070305015034.GG3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : ThinkPad doesn't resume from suspend to RAM
References : http://lkml.org/lkml/2007/2/27/80
             http://lkml.org/lkml/2007/2/28/348
Submitter  : Jens Axboe <jens.axboe@oracle.com>
             Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


Subject    : beeps get longer after suspend
References : http://lkml.org/lkml/2007/2/26/276
Submitter  : Pavel Machek <pavel@ucw.cz>
Status     : unknown


Subject    : ThinkPad T60: no screen after suspend to RAM
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Status     : unknown


Subject    : ThinkPad Z60m: usb mouse stops working after suspend to ram
References : http://lkml.org/lkml/2007/2/21/413
             http://lkml.org/lkml/2007/2/28/172
Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
             commit 0a6139027f3986162233adc17285151e78b39cac
Handled-By : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Status     : problem is being debugged


Subject    : AE_NOT_FOUND ACPI messages
References : http://bugzilla.kernel.org/show_bug.cgi?id=8066
             http://lkml.org/lkml/2007/2/27/263
Submitter  : Thomas Meyer <thomas.mey@web.de>
             Meelis Roos <mroos@linux.ee>
Handled-By : Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8066
Status     : patch available


Subject    : Asus M6Ne notebook: ACPI: First battery is not detected
References : http://bugzilla.kernel.org/show_bug.cgi?id=8080
Submitter  : Janosch Machowinski <jmachowinski@gmx.de>
Status     : unknown


Subject    : AT keyboard only works with pci=noacpi
References : http://lkml.org/lkml/2007/3/3/68
Submitter  : Ash Milsted <thatistosayiseenem@gawab.com>
Status     : unknown

