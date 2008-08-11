Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYHKR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYHKR1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYHKR1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:27:43 -0400
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:50772 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751630AbYHKR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:27:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ZkMjDF2/AtHBx6K6NIChOOtebBbxjBQ5LtLX7GwoO+4DawRrRQbG9iYgG0PwZAO/moqs/fjto9SryJeawweM0INLKDNKigM2Z4gCpXSajug0yJ70iZOW4rLm/Rxi8HB7;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Mon, 11 Aug 2008 10:27:38 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111027.38682.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

The most exciting thing in this set is the MSI restore fix.  It should get
suspend/resume working again on several machines.  Shortlog & diffstat
below.

-- 
Jesse Barnes, Intel Open Source Technology Center

Andrew Morton (1):
      PCI: make pci_register_driver() a macro

Dean Hildebrand (1):
      PCI: Limit VPD length for Broadcom 5708S

Dmitry Baryshkov (1):
      DMA: make dma-coherent.c documentation kdoc-friendly

Eric Dumazet (1):
      PCI: add Broadcom 5708S to VPD length quirk

Jesse Barnes (1):
      PCI: fully restore MSI state at resume time

Rafael J. Wysocki (1):
      PCI PM: Export pci_pme_active to drivers

Simon Horman (1):
      PCI: check the return value of device_create_bin_file() in pci_create_bus()

akpm@linux-foundation.org (1):
      PCI: remove duplicate symbol from pci_ids.h


 drivers/pci/msi.c       |    5 +--
 drivers/pci/pci.c       |    3 +-
 drivers/pci/probe.c     |   54 +++++++++++++++++++++++++++++++++--------------
 drivers/pci/quirks.c    |    7 +++++-
 include/linux/pci.h     |   11 ++++++---
 include/linux/pci_ids.h |    2 -
 kernel/dma-coherent.c   |   10 ++++----
 7 files changed, 60 insertions(+), 32 deletions(-)
