Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYLSBaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYLSBaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 20:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYLSBaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 20:30:10 -0500
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:47969 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190AbYLSBaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 20:30:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=nAzZMm+UMemshm/DWhfDpyaloLCnkDjfmWaOfMfjF7JZsoCeSB1ekLDAQZ/n7/KYKl8auAv3d0vCrULGfbV4R1JayEtqTxUc/egBCHt3axLGZCSwiwa3S+ttsy1BAbFv;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Thu, 18 Dec 2008 17:30:05 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181730.05714.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

There are a few more regression fixes, mostly for minor hotplug related
issues.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

Hidetoshi Seto (1):
      PCI: fix aer resume sanity check

Justin Chen (1):
      PCI hotplug: acpiphp wants a 64-bit _SUN

Kenji Kaneshige (1):
      PCI: pciehp: fix unexpected power off with pciehp_force

Neil Horman (1):
      PCI hotplug: ibmphp: Fix module ref count underflow

 drivers/pci/hotplug/acpiphp.h      |    2 +-
 drivers/pci/hotplug/acpiphp_core.c |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 drivers/pci/hotplug/ibmphp_core.c  |    5 -----
 drivers/pci/hotplug/pciehp_core.c  |   23 ++++++++++++-----------
 drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
 6 files changed, 17 insertions(+), 21 deletions(-)

