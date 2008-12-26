Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYLZIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYLZIxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYLZIxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:53:38 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:56152 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbYLZIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:53:38 -0500
Date: Fri, 26 Dec 2008 08:53:35 +0000
From: Nick Warne <nick@ukfsn.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [QUESTION] Rather high /proc/interrupts ERR count
Message-ID: <20081226085335.2ecd5cfb@sauron.linicks.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Running 2.6.28 stable.

x86_64 system with AMD Athlon(tm) 64 X2 Dual Core Processor 5200+

The machine runs perfectly fine, but...

...should I be concerned with the rather high ERR count below (this
is after 41 minutes uptime).  I also have to boot with noapic to stop
lockups (nvidia driver, I expect):

           CPU0       CPU1       
  0:        125          1    XT-PIC-XT        timer
  1:       5534         97    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  3:          1          0    XT-PIC-XT      
  4:          1          1    XT-PIC-XT      
  5:      78933      11713    XT-PIC-XT        sata_nv, ohci_hcd:usb2, Intel ICH
  6:          3          0    XT-PIC-XT        floppy
  7:      21189     333431    XT-PIC-XT      
  8:          1          0    XT-PIC-XT        rtc0
  9:          0          0    XT-PIC-XT        acpi
 10:     246562       9267    XT-PIC-XT        eth0
 11:       2296         72    XT-PIC-XT        sata_nv, ehci_hcd:usb1, nvidia
 14:         98         51    XT-PIC-XT        pata_amd
 15:          0          0    XT-PIC-XT        pata_amd
NMI:          0          0   Non-maskable interrupts
LOC:     236200     234958   Local timer interrupts
RES:      33224      73287   Rescheduling interrupts
CAL:        890        964   Function call interrupts
TLB:        982       1127   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:     354616
MIS:          0


-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
