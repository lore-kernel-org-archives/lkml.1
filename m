Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXIRNYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXIRNYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXIRNYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 09:24:08 -0400
Received: from crawleyone.elekta.com ([193.235.128.13]:2915 "EHLO
	crawleyone.elekta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXIRNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 09:24:07 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 09:24:07 EDT
Subject: PCI Interrupt
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 6.5.1 January 21, 2004
Message-ID: <OF031C3237.A0A88CB3-ON8025735A.0048E354-8025735A.00490635@elekta.com>
From: Duncan.Perrett@elekta.com
Date: Tue, 18 Sep 2007 14:17:32 +0100
X-MIMETrack: Serialize by Router on CrawleyOne/Servers/Elekta(Release 6.5.1|January 21, 2004) at
 09/18/2007 02:24:07 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have a CAN PCI card installed on my Ubuntu box.
I understand that PCI interrupts should be level rather than edge
triggered.

The output of cat /proc/interrupts is :-

           CPU0
  0:    1614601    IO-APIC-edge  timer
  1:        164    IO-APIC-edge  i8042
  8:          3    IO-APIC-edge  rtc
  9:          1   IO-APIC-level  acpi
 12:          0    IO-APIC-edge  CAN-ACx-PCI_01
 14:      65786    IO-APIC-edge  ide0
169:       3220   IO-APIC-level  eth0, i915@pci:0000:00:02.0
177:      46459   IO-APIC-level  eth1
209:          0   IO-APIC-level  uhci_hcd:usb3, eth2
217:          2   IO-APIC-level  uhci_hcd:usb1, ehci_hcd:usb4
225:        697   IO-APIC-level  uhci_hcd:usb2
NMI:          0
LOC:    1614399
ERR:          0
MIS:          0

You see that irq 12 CAN-ACx-PCI_01 is edge triggered.
Is there any way of forcing the BIOS to see the interrupt as a
level-triggered one?


*******************Internet Email Confidentiality Footer*******************
The contents of this e-mail message (including any attachments hereto) are
confidential to and are intended to be conveyed for the use of the
recipient to whom it is addressed only. If you receive this transmission in
error, please notify the sender of this immediately and delete the message
from your system. Any distribution, reproduction or use of this message by
someone other than recipient is not authorized and may be unlawful.
Elekta Limited is a company registered in England and Wales whose
registered number is 3244454 and whose registered address is Linac House,
Fleming Way, Crawley, West Sussex, RH10 9RR

