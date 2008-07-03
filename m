Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYGCHFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYGCHFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYGCG51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:27 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:60991 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752872AbYGCCUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:20:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes for 2.6.26
Date: Wed, 2 Jul 2008 19:20:43 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021920.43742.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull some PCI fixes for 2.6.26:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

This pull includes fixes for a few crashers.  They're not common (an ACPI
hotplug load/unload issue and an issue with the sysfs VPD file, so there's
no need to panic, but this stuff needs to get fixed asap nonetheless.

Thanks,
Jesse

Alex Chiang (1):
      PCI: acpiphp: cleanup notify handler on all root bridges

Ben Hutchings (1):
      PCI: Restrict VPD read permission to root

Benjamin Li (1):
      PCI: Limit VPD read/write lengths for Broadcom 5706, 5708, 5709 rev.

 drivers/pci/access.c               |   14 +++--------
 drivers/pci/hotplug/acpiphp_glue.c |   17 +++++++++++---
 drivers/pci/pci-sysfs.c            |    4 +--
 drivers/pci/pci.h                  |    2 -
 drivers/pci/quirks.c               |   42 +++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 16 deletions(-)
