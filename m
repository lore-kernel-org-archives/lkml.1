Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXDBLoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXDBLoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933962AbXDBLoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:44:10 -0400
Received: from smtp-out1.libero.it ([212.52.84.41]:39167 "EHLO
	smtp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958AbXDBLoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:44:08 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
Date: Mon,  2 Apr 2007 13:44:05 +0200
Message-Id: <JFVCLH$F3BAE0357982714B025306FB8CF4A0C1@libero.it>
Subject: MTRR Problem with 2.6.18-4
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: "Marco" <marco4ever@libero.it>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.3 (R1) (B3pl17)
X-SenderIP: 151.36.194.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Laptop: Sony VAIO VGN-SZ3VP/X
Kernel: 2.6.18-4

I have the following problem with mtrr:

#cat /proc/mtrr
reg00: base=0x00000000 (?? 0MB), size=2048MB: write-back, count=1
reg01: base=0x7ff00000 (2047MB), size=?? 1MB: uncachable, count=1

#lspci -v
01:00.0 VGA compatible controller: nVidia Corporation GeForce Go 7400 (rev a1) (prog-if 00 [VGA])
 Subsystem: Sony Corporation Unknown device 81e6
 Flags: bus master, fast devsel, latency 0, IRQ 5
 Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
 Memory at c0000000 (64-bit, prefetchable) [size=256M]
 Memory at dc000000 (64-bit, non-prefetchable) [size=16M]
 Capabilities: [60] Power Management version 2
 Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
 Capabilities: [78] Express Endpoint IRQ 0
 Capabilities: [100] Virtual Channel
 Capabilities: [128] Power Budgeting

Kernel boot option:
kernel /vmlinuz-2.6.18-4-686 root=/dev/sda3 ro video=vesafb:mtrr,ywrap vga=792 acpi_sleep=s3_bios elevator=cfq resume2=swap:/dev/sda2 

Can you help me to fix the "uncachable" reg?
Thanks

Marco


------------------------------------------------------
Leggi GRATIS le tue mail con il telefonino i-mode™ di Wind
http://click.libero.it/imode


