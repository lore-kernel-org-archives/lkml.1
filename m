Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXCPBZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXCPBZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXCPBZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:25:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:37121 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753497AbXCPBZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:25:01 -0400
X-Provags-ID: V01U2FsdGVkX18jdj4eBscjTqFFTlcIOUeV+nW76Hvv3SD04x77Z3
	AtPJ1OQxywWf9F
From: Norberto Bensa <nbensa@gmx.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: core2 duo, interrupts: is this normal?
Date: Thu, 15 Mar 2007 22:24:54 -0300
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152224.54607.nbensa@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is this output, normal? I meant, why counters on CPU1 is zero? Isn't this 
balanced?

$ cat /proc/interrupts
           CPU0       CPU1
  0:    4180170          0   IO-APIC-edge      timer
  1:       8060          0   IO-APIC-edge      i8042
  7:          0          0   IO-APIC-edge      parport0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          5          0   IO-APIC-edge      i8042
 16:     322297          0   IO-APIC-fasteoi   uhci_hcd:usb3, libata, nvidia, 
EMU10K1
 17:     896399          0   IO-APIC-fasteoi   bttv0, eth0, libata
 18:      72867          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
 19:      27770          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
 20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
 22:          3          0   IO-APIC-fasteoi   ohci1394
 23:        155          0   IO-APIC-fasteoi   HDA Intel
219:     103056          0   PCI-MSI-edge      libata
NMI:          0          0
LOC:    4077613    4077622
ERR:          0
MIS:          0


Many thanks in advance,
Norberto
