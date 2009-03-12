Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZCLMUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZCLMUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZCLMUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:20:18 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56184 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCLMUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:20:16 -0400
Date: Thu, 12 Mar 2009 14:20:12 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: ttyS* names missing in /proc/interrupts?
Message-ID: <Pine.SOC.4.64.0903121418240.11504@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed in 2.6.29-rc7+git: lines corresponding to 8250 ttyS* 
serial ports have no device name in /proc interrupts:

           CPU0
  0:         35    XT-PIC-XT        timer
  1:        338    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          3    XT-PIC-XT
  4:          3    XT-PIC-XT
  6:          5    XT-PIC-XT        floppy
  7:          1    XT-PIC-XT        parport0
  8:          2    XT-PIC-XT        rtc0
  9:         41    XT-PIC-XT        acpi, qla2xxx, tr1
 10:          1    XT-PIC-XT        Intel 82801BA-ICH2
 11:     160060    XT-PIC-XT        uhci_hcd:usb1, uhci_hcd:usb2, lpfc, tr0, eth0, mga@pci:0000:02:00.0
 12:        141    XT-PIC-XT        i8042
 14:      88730    XT-PIC-XT        ata_piix
 15:    1190012    XT-PIC-XT        ata_piix
NMI:          0   Non-maskable interrupts
LOC:    1028718   Local timer interrupts
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0

$ dmesg | grep tty
console [tty0] enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

And similarly on another machine.

-- 
Meelis Roos (mroos@linux.ee)
