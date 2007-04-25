Return-Path: <linux-kernel-owner+w=401wt.eu-S2992738AbXDYN0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992738AbXDYN0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992750AbXDYN0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:26:45 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:16746 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992738AbXDYN0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:26:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: pcmcia - failed to initialize IDE interface
Date: Wed, 25 Apr 2007 15:27:26 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A4012D5E5F@stgw002a.ww002.siemens.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: pcmcia - failed to initialize IDE interface
Thread-Index: AceHPXb0Lx1EHFojQruUPgysWGz7Tg==
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 13:26:43.0179 (UTC) FILETIME=[5D527BB0:01C7873D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[kernel 2.6.20.7, arch=mips, processor=amd au1550]

I'm trying to install a 2.6 kernel on an Alchemy au1550, and having
problem with the pcmcia socket, where I plugged a CompactFlash card. The
card seems to be recognized by the kernel, appears in
/sys/bus/pcmcia/devices, but not in /proc/bus/pccard, and I can't access
the device (/dev/hda).

The relevant console messages:
----------------------------------------------------------------
pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
hda: SanDisk SDCFB-64, CFA DISK drive
ide0: Disabled unable to get IRQ 35.
ide0: failed to initialize IDE interface
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide-cs: ide_register() at 0x102000 & 0x10200e, irq 35 failed
----------------------------------------------------------------

Here is the relevant part of the kernel config:
CONFIG_IDE=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_AU1X00=y

Any help would be greatly appreciated. Please Cc: your response to me.

Best regards,
Fabrice Aeschbacher
