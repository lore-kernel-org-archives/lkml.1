Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbXHEJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbXHEJa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXHEJ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:29:59 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45259 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbXHEJ35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:29:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=TcAM1RCuMlSwEeGbaAmeqKOg4vvAzDjEttSVvRbmhL18DmSmTUk9QqwnR8XEyiXdREgK6OiFTsUnvO+as1rX5eoZEopWg0MWYtUU77jL4KM8cAZWoaJiKmjrQDUYV7jy;
Message-ID: <46B59892.7040504@simon.arlott.org.uk>
Date: Sun, 05 Aug 2007 10:29:54 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: check_irq_resend warning from pdc202xx_new
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[   36.667137] PDC20269: IDE controller at PCI slot 0000:00:0b.0
[   36.667285] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 12 (level, low) -> IRQ 12
[   36.667450] PDC20269: chipset revision 2
[   36.677550] PDC20269: PLL input clock is 16652 kHz
[   36.707624] PDC20269: 100% native mode on irq 12
[   36.707683]     ide2: BM-DMA at 0xc800-0xc807, BIOS settings: hde:pio, hdf:pio
[   36.707848]     ide3: BM-DMA at 0xc808-0xc80f, BIOS settings: hdg:pio, hdh:pio
[   36.708021] Probing IDE interface ide2...
[   37.187497] hde: WDC WD1200PB-00FBA0, ATA DISK drive
[   38.181060] hde: selected mode 0x45
[   38.182293] ide2 at 0xb800-0xb807,0xbc02 on irq 12
[   38.182816] Probing IDE interface ide3...
[   38.828172] hdg: ST340810A, ATA DISK drive
[   39.922933] hdh: IDE DVD-ROM 16X, ATAPI CD/DVD-ROM drive
[   40.141733] WARNING: at kernel/irq/resend.c:70 check_irq_resend()
[   40.141788]  [<b0104fca>] show_trace_log_lvl+0x1a/0x30
[   40.141882]  [<b0104ff2>] show_trace+0x12/0x20
[   40.141964]  [<b0105105>] dump_stack+0x15/0x20
[   40.142044]  [<b014f09b>] check_irq_resend+0xab/0xb0
[   40.142135]  [<b014e754>] enable_irq+0xb4/0xc0
[   40.142216]  [<b03b138f>] probe_hwif+0x35f/0x4a0
[   40.142301]  [<b03b14df>] probe_hwif_init_with_fixup+0xf/0x90
[   40.142384]  [<b03b4523>] ide_setup_pci_device+0x83/0xb0
[   40.142468]  [<b03a99b8>] init_setup_pdcnew+0x8/0x10
[   40.142558]  [<b03a9ad2>] pdc202new_init_one+0x12/0x20
[   40.142640]  [<b06d76f2>] ide_scan_pcidev+0x42/0x70
[   40.142729]  [<b06d7747>] ide_scan_pcibus+0x27/0xf0
[   40.142811]  [<b06d763d>] probe_for_hwifs+0xd/0x20
[   40.142892]  [<b06d768c>] ide_init+0x3c/0x60
[   40.142972]  [<b06be939>] do_initcalls+0x49/0x1e0
[   40.143056]  [<b06beaec>] do_basic_setup+0x1c/0x30
[   40.143137]  [<b06beba5>] kernel_init+0x55/0xb0
[   40.143218]  [<b0104e57>] kernel_thread_helper+0x7/0x10
[   40.143300]  =======================
[   40.146267] hdg: selected mode 0x45
[   40.149171] hdh: selected mode 0x42
[   40.149548] ide3 at 0xc000-0xc007,0xc402 on irq 12

-- 
Simon Arlott
