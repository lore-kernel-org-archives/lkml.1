Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbXGVJka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbXGVJka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761685AbXGVJkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:40:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:35696 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbXGVJkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:40:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sebastian@breakpoint.cc, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] KVM: Require CONFIG_ANON_INODES
Date: Sun, 22 Jul 2007 12:40:30 +0300
Message-Id: <11850972303808-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Found by Sebastian Siewior and randconfig.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 2f661e5..6cecc39 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -11,6 +11,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
+	select ANON_INODES
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
1.5.2.4

