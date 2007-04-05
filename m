Return-Path: <linux-kernel-owner+w=401wt.eu-S966078AbXDEKlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966078AbXDEKlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966079AbXDEKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:41:00 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50010 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966078AbXDEKk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:40:59 -0400
Date: Thu, 5 Apr 2007 12:40:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: IRQ splitting
Message-ID: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,



let's take the following /proc/interrupts dump (CPU2,CPU3 trimmed)...

           CPU0       CPU1
  0:   37041766   37038991  IO-APIC-edge  timer
  1:         10          2  IO-APIC-edge  i8042
  8:          0          0  IO-APIC-edge  rtc
  9:          0          0  IO-APIC-level  acpi
 12:        114          0  IO-APIC-edge  i8042
 14:      25219    5800049  IO-APIC-edge  ide0
201:     260381     238454  IO-APIC-level  aacraid
209:          0          0  IO-APIC-level  ohci_hcd:usb1
217:          0          0  IO-APIC-level  ehci_hcd:usb2
225:   57531742          0  IO-APIC-level  eth0,radeon@pci:0000:03:00.0
233:         26          0  IO-APIC-level  eth1
NMI:       1661       1397
LOC:  147579966  147579949
ERR:          0
MIS:          0

My question is whether it is possible that eth0's interrupts go to CPU0
and radeon's to CPU1, and if so, how I would enable that. Alternatively,
is it possible to just move eth0 or radeon to a different interrupt?



Jan
-- 
