Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZJLRdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZJLRdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZJLRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:33:08 -0400
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:42991 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757364AbZJLRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:33:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=l/Svol17vhRuM7MP8D3ACFhnIuLr/iRxGQtjdw3DGTvUDJ/jXGu26nUGZ/XWi16EhxQqVzrtckm6J9dcwRhadEu7bcDIkYGBAH0zGwqz2WlzQcPqI6Bd31L+MOA7n5Yw;
Date: Mon, 12 Oct 2009 10:32:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20091012103209.227740bf@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
0eca52a92735f43462165efe00a7e394345fb38e: Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Nothing earth shattering here since there haven't been any big PCI related
regressions reported (yet).  Probably the most significant change here is from
Yinghai; a patch to allocate larger bridge ranges if possible.  It's the only
one with potential to cause big trouble, but it looks safe and doesn't seem
to have caused issues so far...

Bjorn Helgaas (2):
      PCI: PCIe portdrv: remove "-driver" from driver name
      PCI: remove pci_assign_resource_fixed()

Gabe Black (1):
      PCI quirk: TI XIO200a erroneously reports support for fast b2b transfers

Kenji Kaneshige (1):
      PCI: Prevent AER driver from being loaded on non-root port PCIE devices

Rafael J. Wysocki (1):
      PCI PM: Read device power state from register after updating it

Randy Dunlap (1):
      PCI: pci.c: fix kernel-doc notation

Yinghai Lu (1):
      PCI: get larger bridge ranges when space is available

 drivers/pci/pci.c              |   14 +++++++++-----
 drivers/pci/pcie/aer/aerdrv.c  |    2 +-
 drivers/pci/pcie/portdrv_pci.c |    3 +--
 drivers/pci/quirks.c           |   19 +++++++++++++++++++
 drivers/pci/setup-bus.c        |   13 +++++++++++--
 drivers/pci/setup-res.c        |   37 -------------------------------------
 include/linux/pci_ids.h        |    1 +
 7 files changed, 42 insertions(+), 47 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
