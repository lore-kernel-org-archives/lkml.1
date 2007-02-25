Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXBYRwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXBYRwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965054AbXBYRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:52:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43894 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965049AbXBYRwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:52:47 -0500
Date: Sun, 25 Feb 2007 18:52:47 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
       linux-pm@lists.osdl.org, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       linux-usb-devel@lists.sourceforge.net, Thomas Meyer <thomas.mey@web.de>,
       Andrew <andrew@nelless.net>, Janosch Machowinski <jmachowinski@gmx.de>,
       vladimir.p.lebedev@intel.com, Lukas Hejtmanek <xhejtman@fi.muni.cz>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Meelis Roos <mroos@linux.ee>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Jean-Luc Coulon <jean.luc.coulon@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.21-rc1: known regressions (part 1)
Message-ID: <20070225175247.GB12392@stusta.de>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : resume: slab error in verify_redzone_free(): cache `size-512':
                     memory outside object was overwritten
References : http://lkml.org/lkml/2007/2/24/41
Submitter  : Pavel Machek <pavel@ucw.cz>
Handled-By : Marcel Holtmann <marcel@holtmann.org>
Status     : unknown


Subject    : ThinkPad T60: no screen after suspend to RAM
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : HP nx6325 notebook: usb mouse stops working after suspend to ram
References : http://lkml.org/lkml/2007/2/21/413
Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
             commit 0a6139027f3986162233adc17285151e78b39cac
Status     : unknown


Subject    : MacBook: AE_NOT_FOUND ACPI messages
References : http://bugzilla.kernel.org/show_bug.cgi?id=8066
Submitter  : Thomas Meyer <thomas.mey@web.de>
Status     : unknown


Subject    : Asus A8N-VM motherboard: boot failure (ACPI related)
References : http://lkml.org/lkml/2007/2/23/132
Submitter  : Andrew <andrew@nelless.net>
Status     : unknown


Subject    : Asus M6Ne notebook: ACPI: First battery is not detected
References : http://bugzilla.kernel.org/show_bug.cgi?id=8080
Submitter  : Janosch Machowinski <jmachowinski@gmx.de>
Status     : unknown


Subject    : Asus M6Ne/M6A notebooks: SATA_ACPI errors during kernel boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8080
             http://bugzilla.kernel.org/show_bug.cgi?id=8046
Submitter  : Janosch Machowinski <jmachowinski@gmx.de>
             Lukas Hejtmanek <xhejtman@fi.muni.cz>
Status     : unknown


Subject    : ata-piix ACPI errors (40/80 pin cable mix)
References : http://lkml.org/lkml/2007/2/22/159
Submitter  : Meelis Roos <mroos@linux.ee>
Handled-By : Alan Cox <alan@lxorguk.ukuu.org.uk>
Status     : unknown


Subject    : ata_piix: PATA UDMA/100 configured as UDMA/33
References : http://lkml.org/lkml/2007/2/20/294
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
Status     : unknown


Subject    : sata_via failure
References : http://bugzilla.kernel.org/show_bug.cgi?id=8025
Submitter  : Jean-Luc Coulon <jean.luc.coulon@gmail.com>
             Markus Trippelsdorf <markus@trippelsdorf.de>
Handled-By : Tejun Heo <htejun@gmail.com>
Patch      : http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03945.html
Status     : patch available


Subject    : BUG: at drivers/pci/pci.c:817 pcim_enable_device() (suspend, ata)
References : http://lkml.org/lkml/2007/2/14/275
             http://lkml.org/lkml/2007/2/22/367
Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
             Lukas Hejtmanek <xhejtman@mail.muni.cz>
Handled-By : Tejun Heo <htejun@gmail.com>
Patch      : http://lkml.org/lkml/2007/2/25/102
Status     : patch available


