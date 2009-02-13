Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZBMWHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZBMWHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZBMWHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:07:13 -0500
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:55134 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753559AbZBMWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:07:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=oHKEoIYjXEGZ8y/jh66ssQNPZfQLvb5XfkAt+RPDnez4t+vHjXq2hh5QetKS270pAo468FVSo7ytYQNplZKMyDZ9ebFSiXCK2+0WR6vsslm4P3yRF5n0dKTwnpWJy20H;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [git pull] PCI fixes
Date: Fri, 13 Feb 2009 14:07:09 -0800
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131407.10154.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

The only real fix here is the fix for the MSI mask fix, the other stuff is
just documentation.

Alex Chiang (1):
      PCI: Documentation: fix minor PCIe HOWTO thinko

Matthew Wilcox (1):
      PCI/MSI: fix msi_mask() shift fix

Randy Dunlap (3):
      PCI: fix rom.c kernel-doc warning
      PCI: fix struct pci_platform_pm_ops kernel-doc
      PCI: fix missing kernel-doc and typos

 Documentation/PCI/PCIEBUS-HOWTO.txt |    2 +-
 drivers/pci/msi.c                   |   10 ++++------
 drivers/pci/pci.c                   |   13 +++++++++----
 drivers/pci/pci.h                   |   20 ++++++++++----------
 drivers/pci/rom.c                   |    1 +
 5 files changed, 25 insertions(+), 21 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
