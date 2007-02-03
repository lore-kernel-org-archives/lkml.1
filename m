Return-Path: <linux-kernel-owner+w=401wt.eu-S1946436AbXBCKug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946436AbXBCKug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946438AbXBCKug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:50:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41947 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946436AbXBCKuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:50:35 -0500
Date: Sat, 3 Feb 2007 01:24:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: x60: mmc card reader problem
Message-ID: <20070203002443.GA3031@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...it wants me to report:


...yes, I yanked the card when I seen "unknown partition table".

(This is how it looks on debug console; it captured the dumps, too:)

									Pavel


Feb  3 01:21:43 amd kernel: mmcblk0: mmc0:0001 IFX128 125440KiB
Feb  3 01:21:43 amd kernel:  mmcblk0:<3>mmcblk0: error 1 transferring
data
<???>
Feb  3 01:21:43 amd kernel: end_request: I/O error, dev mmcblk0, sector 0
Feb  3 01:21:43 amd kernel: Buffer I/O error on device mmcblk0, logical block 0
Feb  3 01:21:43 amd kernel: ldm_validate_partition_table(): Disk read failed.
Feb  3 01:21:43 amd kernel: mmcblk0: error 1 transferring data
Feb  3 01:21:43 amd kernel: end_request: I/O error, dev mmcblk0, sector 0
Feb  3 01:21:43 amd kernel: Buffer I/O error on device mmcblk0, logical block 0
Feb  3 01:21:44 amd kernel:  unknown partition table

Feb  3 01:21:57 amd kernel: mmc0: Card removed during transfer!
Feb  3 01:21:57 amd kernel: mmc0: Resetting controller.
Feb  3 01:21:57 amd kernel: mmc0: Got command interrupt even though no command operation was in progress.
Feb  3 01:21:57 amd kernel: mmc0: Please report this to <sdhci-devel@list.drzeus.cx>.
Feb  3 01:21:57 amd kernel: sdhci: ============== REGISTER DUMP ==============
Feb  3 01:21:57 amd kernel: sdhci: Sys addr: 0x2e984000 | Version:  0x00000200
Feb  3 01:21:57 amd kernel: sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
Feb  3 01:21:57 amd kernel: sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
Feb  3 01:21:57 amd kernel: sdhci: Present:  0x01f80001 | Host ctl: 0x00000001
Feb  3 01:21:57 amd kernel: sdhci: Power:    0x0000000e | Blk gap:  0x00000000
Feb  3 01:21:57 amd kernel: sdhci: Wake-up:  0x00000000 | Clock:    0x00008007
Feb  3 01:21:57 amd kernel: sdhci: Timeout:  0x00000006 | Int stat: 0x00038000
Feb  3 01:21:57 amd kernel: sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
Feb  3 01:21:57 amd kernel: sdhci: AC12 err: 0x00000000 | Slot int: 0x00000001
Feb  3 01:21:57 amd kernel: sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
Feb  3 01:21:57 amd kernel: sdhci: ===========================================
Feb  3 01:21:57 amd kernel: mmc0: Got command interrupt even though no command operation was in progress.
Feb  3 01:21:57 amd kernel: mmc0: Please report this to <sdhci-devel@list.drzeus.cx>.
Feb  3 01:21:57 amd kernel: sdhci: ============== REGISTER DUMP ==============
Feb  3 01:21:57 amd kernel: sdhci: Sys addr: 0x2e984000 | Version:  0x00000200
Feb  3 01:21:57 amd kernel: sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
Feb  3 01:21:57 amd kernel: sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
Feb  3 01:21:57 amd kernel: sdhci: Present:  0x01f80001 | Host ctl: 0x00000001
Feb  3 01:21:57 amd kernel: sdhci: Power:    0x0000000e | Blk gap:  0x00000000
Feb  3 01:21:57 amd kernel: sdhci: Wake-up:  0x00000000 | Clock:    0x00008007
Feb  3 01:21:57 amd kernel: sdhci: Timeout:  0x00000006 | Int stat: 0x00000000
Feb  3 01:21:57 amd kernel: sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
Feb  3 01:21:57 amd kernel: sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
Feb  3 01:21:57 amd kernel: sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
Feb  3 01:21:57 amd kernel: sdhci: ===========================================
Feb  3 01:21:57 amd kernel: PM: Removing info for mmc:mmc0:0001


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
