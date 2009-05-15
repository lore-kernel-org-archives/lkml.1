Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZEOWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZEOWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZEOWJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:09:47 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:58905 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754073AbZEOWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:09:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OI4NFGCO87GbXwElf9yBP9IBj73lvISwgeJn2khM3Xq2p4pitCTkICSQyav7v36NQAWicG5jZFvGsguHvD5aV/qnNNXjbmlS1vRUICJE/1kb2eiPs9tyiCRZtg2MSebH;
Date: Fri, 15 May 2009 15:09:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090515150942.3515bcd5@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling the PCI fixes from
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

The MSI fix has been tested and fixes the problem Dave reported.  It's
not a complete fix (i.e. it doesn't prevent writes to MSI regs when
MSI is disabled), but I'd rather have the tested one upstream at this
point than delay things further. We can fix the more theoretical
problems in linux-next (there's ongoing discussion about the best way
to do this).

Matthew Wilcox (1):
      PCI MSI: Fix MSI-X with NIU cards

Zhang, Yanmin (1):
      PCI: Fix pci-e port driver slot_reset bad default return value

 drivers/pci/msi.c              |    8 ++++++--
 drivers/pci/pcie/aer/aerdrv.h  |    3 +++
 drivers/pci/pcie/portdrv_pci.c |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
