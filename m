Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYKGRAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYKGRAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYKGRAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:00:45 -0500
Received: from outbound-mail-156.bluehost.com ([67.222.39.36]:53905 "HELO
	outbound-mail-156.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751676AbYKGRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:00:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ppnf1hK+rsdWfoJeo8PdeCLFOKnS5iQcloj29Me4AcsDvYVS+g/wfP46ope1vrNMsYrAjfReFA4S/gYKN0eMrKk+ugK8CIafTbXDL6KIoG8FGtdjFqbb2tt/o1np4Vh9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Fri, 7 Nov 2008 09:00:41 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811070900.41612.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

A few more fixes for 2.6.28.

Thanks,
Jesse

Ed Swierk (1):
      PCI: fix range check on mmapped sysfs resource files

Harvey Harrison (1):
      PCI: annotate return value of pci_ioremap_bar with __iomem

Randy Dunlap (1):
      PCI: remove excess kernel-doc notation

Yu Zhao (1):
      PCI: fix VPD limit quirk for Broadcom 5708S

 drivers/pci/pci-sysfs.c |    2 +-
 drivers/pci/quirks.c    |   36 ++++++++++++++++++------------------
 drivers/pci/rom.c       |    6 ++++--
 include/linux/pci.h     |    2 +-
 4 files changed, 24 insertions(+), 22 deletions(-)

