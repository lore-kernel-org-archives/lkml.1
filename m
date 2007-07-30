Return-Path: <linux-kernel-owner+w=401wt.eu-S968003AbXG3UCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968003AbXG3UCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763365AbXG3UB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:01:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:10468 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762861AbXG3UB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ByGhXCr3Z2DwR8EtSxhRFKHXQ3i2p+qUYb/FM61DGT835tEin8PgFYdBrF8JLmBxfHwiOKIK8vEH9BaCm057X1hIN2cb9raOPKG7PRw2h8VVgdsYo44lA1lTzMCojwyFpkCYNFHlIwyr8w9iPiE3lxinu9b7jtZxDaAxNJeXnOs=
Message-ID: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
Date: Mon, 30 Jul 2007 22:01:56 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: forcedeth ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi people,

I'm using this on a x86-64 amd machine. During boot of the last
2.6.22.1 kernel I get this error:

fb0: VESA VGA frame buffer device
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Marvell 88E1101: Registered new driver
Marvell 88E1111: Registered new driver
Marvell 88E1145: Registered new driver
Fixed PHY: Registered new driver
Device 'fixed@100:1' does not have a release() function, it is broken
and must be fixed.
WARNING: at drivers/base/core.c:107 device_release()

Call Trace:
 [<ffffffff802f16c8>] kobject_cleanup+0x52/0x70
 [<ffffffff802f16e6>] kobject_release+0x0/0x9
 [<ffffffff802f237a>] kref_put+0x74/0x82
 [<ffffffff8035c0be>] fixed_mdio_register_device+0x1f3/0x229
 [<ffffffff805884f6>] fixed_init+0x1f/0x35
 [<ffffffff80216e2d>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff80570910>] kernel_init+0x16f/0x2d5
 [<ffffffff8020a458>] child_rip+0xa/0x12
 [<ffffffff8031763c>] acpi_ds_init_one_object+0x0/0x7f
 [<ffffffff805707a1>] kernel_init+0x0/0x2d5
 [<ffffffff8020a44e>] child_rip+0x0/0x12

Device 'fixed@10:1' does not have a release() function, it is broken
and must be fixed.
WARNING: at drivers/base/core.c:107 device_release()

Call Trace:
 [<ffffffff802f16c8>] kobject_cleanup+0x52/0x70
 [<ffffffff802f16e6>] kobject_release+0x0/0x9
 [<ffffffff802f237a>] kref_put+0x74/0x82
 [<ffffffff8035c0be>] fixed_mdio_register_device+0x1f3/0x229
 [<ffffffff80588507>] fixed_init+0x30/0x35
 [<ffffffff80216e2d>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff80570910>] kernel_init+0x16f/0x2d5
 [<ffffffff8020a458>] child_rip+0xa/0x12
 [<ffffffff8031763c>] acpi_ds_init_one_object+0x0/0x7f
 [<ffffffff805707a1>] kernel_init+0x0/0x2d5
 [<ffffffff8020a44e>] child_rip+0x0/0x12

forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LMAC] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:07.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01849:03ef bound to 0000:00:07.0
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP61: IDE controller at PCI slot 0000:00:06.0

If somebody needs some additional info please cc me.

Best Regards
Sasa Ostrouska
