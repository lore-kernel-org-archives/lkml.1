Return-Path: <linux-kernel-owner+w=401wt.eu-S1946437AbXBCKue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946437AbXBCKue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946438AbXBCKue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:50:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41948 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946437AbXBCKud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:50:33 -0500
Date: Sat, 3 Feb 2007 01:25:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: Re: x60: mmc card reader problem
Message-ID: <20070203002540.GA3071@elf.ucw.cz>
References: <20070203002443.GA3031@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203002443.GA3031@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ...it wants me to report:
> 
> 
> ...yes, I yanked the card when I seen "unknown partition table".
> 
> (This is how it looks on debug console; it captured the dumps, too:)

Well, it seems it recovered after one more reinsert:

Feb  3 01:24:49 amd kernel: mmc0: Controller never released inhibit bit(s). Please report this to <sdhci-devel@list.drzeus.cx>.
Feb  3 01:24:49 amd kernel: sdhci: ============== REGISTER DUMP ==============
Feb  3 01:24:49 amd kernel: sdhci: Sys addr: 0x2e984000 | Version:  0x00000200
Feb  3 01:24:49 amd kernel: sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
Feb  3 01:24:49 amd kernel: sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
Feb  3 01:24:49 amd kernel: sdhci: Present:  0x01ff0001 | Host ctl: 0x00000001
Feb  3 01:24:49 amd kernel: sdhci: Power:    0x0000000f | Blk gap:  0x00000000
Feb  3 01:24:49 amd kernel: sdhci: Wake-up:  0x00000000 | Clock:    0x00008007
Feb  3 01:24:49 amd kernel: sdhci: Timeout:  0x00000006 | Int stat: 0x00000000
Feb  3 01:24:49 amd kernel: sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
Feb  3 01:24:49 amd kernel: sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
Feb  3 01:24:49 amd kernel: sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
Feb  3 01:24:49 amd kernel: sdhci: ===========================================
Feb  3 01:24:49 amd kernel: PM: Adding info for mmc:mmc0:0001
Feb  3 01:24:49 amd kernel: mmcblk0: mmc0:0001 IFX128 125440KiB
Feb  3 01:24:49 amd kernel:  mmcblk0: p1 p2 p3

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
