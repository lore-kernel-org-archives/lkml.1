Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435Ab0AGWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0AGWeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910Ab0AGWen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:34:43 -0500
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:56350 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753356Ab0AGWei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:34:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RzHfeUG7y9wvtxr0HQ89PNrSsM+4Lkf+neOHLqD+yWoqFJvpxBQR2lQl7sUyLpcELOxoYWh03c/37g9jfDP8fZWBzz1kTxZVrWhyGBPrk9dNbUflSkk+EnEWdl/FcRQ0;
Date: Thu, 7 Jan 2010 14:34:36 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100107143436.70529b51@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

A few misc fixes since the last request, including a fix from Rafael to allow
devices to resume more reliably (namely those that need extra time to come
back from D3).

David John (1):
      PCI: Check the node argument passed to cpumask_of_node

Hidetoshi Seto (1):
      PCI: pcie portdrv: style cleanup

Rafael J. Wysocki (1):
      PCI/PM: Use per-device D3 delays

Youquan,Song (2):
      PCI: AER: fix aer inject result in kernel oops
      PCIe AER: prevent AER injection if hardware masks error reporting

 drivers/net/sky2.c                |    1 +
 drivers/pci/pci-sysfs.c           |    6 ++++--
 drivers/pci/pci.c                 |   19 +++++++++++++++----
 drivers/pci/pcie/aer/aer_inject.c |   28 ++++++++++++++++++++++++++--
 drivers/pci/pcie/portdrv_core.c   |   16 +++++++---------
 drivers/pci/pcie/portdrv_pci.c    |   17 ++++++++---------
 include/linux/pci.h               |    1 +
 7 files changed, 62 insertions(+), 26 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
