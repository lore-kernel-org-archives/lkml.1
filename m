Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbZJNQXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbZJNQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761707AbZJNQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:23:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36129 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbZJNQXQ (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 12:23:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [ALACRITYVM PATCH 0/2] render shm-signals as standard irqs
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Date: Wed, 14 Oct 2009 12:22:30 -0400
Message-ID: <20091014162030.19298.48508.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series applies to the "linux-next" branch for alacrity-vm.git:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2.6.git

Please see the patch headers for details.

Kind Regards,
-Greg

---

Gregory Haskins (2):
      vbus: register shm-signal events as standard Linux IRQ vectors
      vbus: allow shmsignals to be named


 drivers/net/vbus-enet.c     |   43 ++++++++++++++++----
 drivers/vbus/Kconfig        |    4 +-
 drivers/vbus/bus-proxy.c    |    6 +--
 drivers/vbus/pci-bridge.c   |   94 ++++++++++++++++++++++++++++++++++---------
 include/linux/vbus_driver.h |    7 ++-
 5 files changed, 117 insertions(+), 37 deletions(-)

-- 
Signature
