Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYJHWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYJHWV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYJHWVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:21:16 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:57111 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756826AbYJHWVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:21:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=PAeX3WKKc6nCAqVnqkhkqxPRXIDvisq7Aa3utomRWjkOjViud7vkc01MrhG9i/bAnYVt9AF2543se9oHw4Sas48M5DHWfU2Ta45lbgqckvBmCBtQM19kdkZT8ASxEOwB;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: What's in pci-2.6.git
Date: Wed, 8 Oct 2008 15:21:10 -0700
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081521.10262.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few patches have queued up in my linux-next branch for 2.6.28, and a 
couple of more are still pending (they've seen lots of review so should be 
just about ready), specifically the I/O virtualization code and more PCI slot 
driver fixes from Alex and Kenji-san.

Full shortlog below, there's stuff all over the map...

Jesse

Alex Chiang (1):
      PCI: connect struct pci_dev to struct pci_slot

Andi Kleen (1):
      PCI: Document that most pci options are shared between i386 and x86-64

Arjan van de Ven (1):
      PCI: introduce an pci_ioremap(pdev, barnr) function

Bjorn Helgaas (3):
      x86/PCI: follow lspci device/vendor style
      PCI: follow lspci device/vendor style
      PCI: tidy PME support messages

Chuck Ebbert (1):
      PCI: document the pcie_aspm kernel parameter

Greg Kroah-Hartman (1):
      PCI: fix compiler warnings in pci_get_subsys()

Jean Delvare (1):
      PCI: Check dynids driver_data value for validity

Jeff Garzik (1):
      PCI: documentation fix for pci_dma_mapping_error

Jesse Barnes (5):
      PCI: fix -Wakpm warnings in pci_pm_init debug output
      PCI: remove #ifdef DEBUG around dev_dbg call
      PCI: pcie whitespace cleanup
      PCI: fix PCI sysfs rom file size for shadowed ROMs
      PCI: use pci_find_ext_capability everywhere

Jike Song (1):
      PCI: utilize calculated results when detecting MSI features

Kenji Kaneshige (2):
      PCI: pciehp: fix irq initialization
      PCI: fix get_##name merge error

Mike Travis (1):
      PCI: make CPU list affinity visible

Milton Miller (1):
      PCI: remove dynids.use_driver_data

Rafael J. Wysocki (1):
      PCI PM: Introduce function pci_wake_from_d3

Roland Dreier (1):
      PCI: fix MSI-HOWTO.txt info about MSI-X MMIO space

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Ibex Peak DeviceIDs

Stephen Hemminger (1):
      PCI: fix sparse warning in pci_remove_behind_bridge

Stephen Rothwell (1):
      PCI: hotplug/rpaphp: remove unused error path code

Taku Izumi (2):
      PCI: pciehp: change name tag of "hpdriver_portdrv" variable
      PCI: pciehp: replace printk with dev_printk

Thomas Petazzoni (1):
      PCI: allow quirks to be compiled out

Yinghai Lu (2):
      PCI: change MSI-x vector to 32bit
      PCI: use %pF instead of print_fn_descriptor_symbol() in quirks.c

Zhang, Yanmin (1):
      PCI: merge define of PCI_CFG_SPACE_SIZE

Zhao, Yu (1):
      PCI: fix hotplug get_##name return value problem

akpm@linux-foundation.org (2):
      PCI: ibmphp: list_for_each to list_for_each_entry
      PCI: ibmphp: list_for_each to list_for_each_entry-checkpatch cleanups
