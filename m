Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYIANWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYIANWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYIANWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:22:36 -0400
Received: from NAT-170.Local.iNES.RO ([80.86.100.170]:56315 "EHLO
	blade.ines.ro" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbYIANWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:22:35 -0400
X-Greylist: delayed 1380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 09:22:35 EDT
Subject: IRQ routing / assignment issue
From: Radu Rendec <radu.rendec@ines.ro>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 01 Sep 2008 15:59:32 +0300
Message-Id: <1220273972.16764.14.camel@blade.ines.ro>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to make the kernel assign different irqs for two NICs
connected to _separate_ pci buses. Messing around with pirq= kenrel
parameter didn't seem to change anything.

The machine is a smp (dual-xeon). Relevant lspci output is:
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
Gigabit Ethernet PCI Express (rev 11)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
Gigabit Ethernet PCI Express (rev 11)

IRQ assignment dmesg output is:
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16

At the moment I'm almost clueless about how irq routing / assignment
works (either in general or in linux), so any suggestion would help -
even "rtfm" would be helpful, as long as you specify what is the
appropriate manual ;)

If you are so kind to reply, please include my address in cc (I'm not
subscribed).

Thanks,

Radu Rendec


