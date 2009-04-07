Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbZDGSAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbZDGSAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZDGSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:00:44 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:60276 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756952AbZDGSAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:00:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Kju8kSzfMCn5YHxRyAh05sfa2jEzXL95PBlvWLVPkoqVCzy9JYtDIEdg5B17hLOfhKSZwHydrWsj3DseihDbVfxvQMTMzeTvBI0Wiyut/BwCE3WsjpsDYH+I/8pMVdHv;
Date: Tue, 7 Apr 2009 11:00:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090407110040.68293389@hobbes>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my for-linus branch from:
  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

This has the fix for the sky2 VPD bug, as well as a few others related
to the newly merged code.

Alex Chiang (4):
      PCI: annotate pci_rescan_bus as __ref, not __devinit
      PCI: allow PCI core hotplug to remove PCI root bus
      PCI Hotplug: acpiphp: grab refcount on p2p subordinate bus
      PCI: pci_slot: grab refcount on slot's bus

Anton Vorontsov (1):
      PCI: Fix oops in pci_vpd_truncate

Randy Dunlap (1):
      PCI-IOV: fix missing kernel-doc

Yu Zhao (1):
      PCI: SR-IOV quirk for Intel 82576 NIC

Yuji Shimada (2):
      PCI: Setup disabled bridges even if buses are added
      PCI: don't corrupt enable_cnt when doing manual resource alignment

 drivers/acpi/pci_slot.c            |    5 +++
 drivers/pci/access.c               |    3 +-
 drivers/pci/bus.c                  |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++
 drivers/pci/iov.c                  |    1 +
 drivers/pci/pci-sysfs.c            |    6 +---
 drivers/pci/pci.c                  |    4 +-
 drivers/pci/probe.c                |    2 +-
 drivers/pci/quirks.c               |   62 +++++++++++++++++++++++++++++++++---
 drivers/pci/setup-bus.c            |    2 +-
 include/linux/pci.h                |    5 +++
 11 files changed, 90 insertions(+), 16 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
