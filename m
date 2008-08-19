Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYHSREH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYHSREH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYHSRDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:03:47 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:52796 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756882AbYHSRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:03:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pOvYBSVlTCkwwoWu1dBSM3uY0oJDs7cqHFdzLQ+CAARfK2Mzkv5GbXlwaoF9Cokp2YZoqzZO/7ds/LxBpGOPweF0qwnb1vYPwMN5ZQPFD3DtVbw01VEUg9HTcODQfM73;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Tue, 19 Aug 2008 10:03:41 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191003.41547.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

This one is mostly misc. fixes that have been soaking for awhile.  We still
need to resolve the PCI hotplug slot naming stuff a bit better, but we've
got patches for that which will probably be ready for the next pull request.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center


Andi Kleen (1):
      x86/PCI: allow scanning of 255 PCI busses

Ingo Molnar (1):
      Merge branch 'linus' into pci-for-jesse

Jesse Barnes (2):
      Merge branch 'pci-for-jesse' of git://git.kernel.org/.../tip/linux-2.6-tip into x86-merge
      Merge branch 'x86-merge' into for-linus

Jiri Slaby (2):
      PCI: acpi_pcihp: run _OSC on a root bridge
      PCI: add acpi_find_root_bridge_handle

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for Intel Ibex Peak PCHs

Yinghai Lu (3):
      pci: debug extra pci resources range
      pci: debug extra pci bus resources
      x86, pci: detect end_bus_number according to acpi/e820 reserved, v2

 arch/x86/pci/irq.c                 |    2 +
 arch/x86/pci/legacy.c              |    2 +-
 arch/x86/pci/mmconfig-shared.c     |   65 ++++++++++++++++++++++++++---------
 drivers/pci/hotplug/acpi_pcihp.c   |   38 ++++++++++++++-------
 drivers/pci/pcie/aer/aerdrv_acpi.c |    7 +---
 drivers/pci/probe.c                |    3 ++
 drivers/pci/setup-bus.c            |   35 +++++++++++++++++++
 include/linux/pci-acpi.h           |   11 ++++++
 include/linux/pci_ids.h            |    3 ++
 9 files changed, 130 insertions(+), 36 deletions(-)
