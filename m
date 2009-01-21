Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZAUWAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZAUWAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZAUWAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:00:35 -0500
Received: from outbound-mail-309.bluehost.com ([67.222.54.2]:53013 "HELO
	outbound-mail-309.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752476AbZAUWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:00:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=LrEh1LgVEhAeG53EjyDIfZNRuFqZoUx5hhks27s7Z350jVQgstavyfXVVCO4bbIjFkZdZxKJBBNDYsFx9gs9HA4CnAMEh5g4q67vBiI+/5Rl89n3c9mYLlE8wrsLzQ2y;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Wed, 21 Jan 2009 14:00:22 -0800
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211400.22468.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

It only contains a few fixes, the most notable being Rafael's change to restore
PCI config space early, fixing bugs on various platforms.

Shortlog & diffstat below.

-- 
Jesse Barnes, Intel Open Source Technology Center

Hidetoshi Seto (1):
      PCI/MSI: bugfix/utilize for msi_capability_init()

Jiri Slaby (1):
      PCI hotplug: fix lock imbalance in pciehp

Rafael J. Wysocki (1):
      PCI PM: Restore standard config registers of all devices early

 drivers/pci/hotplug/pciehp_core.c |    4 +-
 drivers/pci/msi.c                 |   16 +++----
 drivers/pci/pci-driver.c          |   91 +++++++++++--------------------------
 drivers/pci/pci.c                 |   63 +++++++++++++++++++++++---
 drivers/pci/pci.h                 |    6 +++
 include/linux/pci.h               |    5 ++
 6 files changed, 105 insertions(+), 80 deletions(-)
