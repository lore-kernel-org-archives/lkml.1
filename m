Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZBCCTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZBCCTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZBCCTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:19:23 -0500
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:47198 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750977AbZBCCTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:19:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Rj6XfJcqaC6kWJToMLNoaQhoXgj8Qet8k1IpUo05nDTrOr/GlHLLQfvJWcjqZiRCPyqRgq/3A/MTXWRW61rMZIvSjUo+cPhZKss63K/gM7sdsUy21uERP4o2wTypgg4a;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: [git pull] PCI fixes
Date: Mon, 2 Feb 2009 18:19:19 -0800
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021819.19436.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

A few more fixes for this round (and a few more pending, want to get them
through linux-next first though).  There's one patch for new hw support here,
but it's a two liner, and missing a whole release would be a pain, so I'm
including it; hope that's not a problem.

-- 
Jesse Barnes, Intel Open Source Technology Center

Darrick J. Wong (1):
      PCI hotplug: fakephp: Allocate PCI resources before adding the device

Matthew Garrett (1):
      PCI hotplug: Change link order of pciehp & acpiphp

Matthew Wilcox (1):
      PCI MSI: Fix undefined shift by 32

Rafael J. Wysocki (4):
      PCI PM: Fix suspend error paths and testing facility breakage
      PCI PM: Fix hibernation breakage on EeePC 701
      PCI PM: Power up devices before restoring their state
      PCI PM: Do not wait for buses in B2 or B3 during resume

Seth Heasley (1):
      PCI: irq and pci_ids patch for Intel Tigerpoint DeviceIDs

 arch/x86/pci/irq.c            |    1 +
 drivers/pci/hotplug/Makefile  |    6 ++++-
 drivers/pci/hotplug/fakephp.c |   42 +++++++++++++++++++++++++---------------
 drivers/pci/msi.c             |   13 ++++++++++-
 drivers/pci/pci-driver.c      |   21 +++++++++++++++++++-
 drivers/pci/pci.c             |   32 +++++++++++++++---------------
 include/linux/pci_ids.h       |    1 +
 7 files changed, 80 insertions(+), 36 deletions(-)
