Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbZCaP2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbZCaP2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762424AbZCaPYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:15 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11929 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762360AbZCaPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:24:14 -0400
Subject: [PATCH 13/15] PCI Hotplug: cpqphp: constify slot_name()
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:24:12 -0600
Message-ID: <20090331152412.26622.43737.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate this warning:
	warning: return discards qualifiers from pointer target type

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 1d5561c..5383600 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -464,7 +464,7 @@ extern u8 cpqhp_disk_irq;
 
 /* inline functions */
 
-static inline char *slot_name(struct slot *slot)
+static inline const char *slot_name(struct slot *slot)
 {
 	return hotplug_slot_name(slot->hotplug_slot);
 }

