Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYIMACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYIMACq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbYIMACh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:02:37 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:46882 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753680AbYIMACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:02:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DGFWAdcqqqjtCNCIaEH1HjQjWVt8TZn6a6Ggu6ZB13tIbOcURX+gIJvOFrcQfyW8bXUx23w1a7z2Zo6kllGK9GiZX5tMquJGFCLRxr/86wYX0JKMvx/Bur6pka3uo01/;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Fri, 12 Sep 2008 17:02:34 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121702.34242.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, sir, please pull some more:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

This pull has a few more regression fixes, though I don't think any are listed
on Rafael's list atm.  The fakephp and iommu fixes are the most important, but
the others are definite regressions vs. earlier kernels as well, but don't have
very visible symptoms in most configurations.

Adrian Bunk (1):
      PCI: fix pciehp_free_irq()

Alex Chiang (1):
      PCI Hotplug: fakephp: fix deadlock... again

David Woodhouse (1):
      PCI/iommu: blacklist DMAR on Intel G31/G33 chipsets

Johann Felix Soden (2):
      PCI: Fix printk warnings in probe.c
      PCI: Fix printk warnings in setup-bus.c

Yinghai Lu (1):
      PCI: re-add debug prints for unmodified BARs


 drivers/pci/hotplug/fakephp.c    |    6 +++---
 drivers/pci/hotplug/pciehp_hpc.c |    2 +-
 drivers/pci/intel-iommu.c        |   23 +++++++++++++++++++++++
 drivers/pci/probe.c              |   18 +++++++++++++++---
 drivers/pci/setup-bus.c          |    6 +++++-
 5 files changed, 47 insertions(+), 8 deletions(-)
