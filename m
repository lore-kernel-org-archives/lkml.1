Return-Path: <linux-kernel-owner+w=401wt.eu-S1761095AbXIQJMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095AbXIQJMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbXIQJKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:10:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:33014 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438AbXIQJKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:10:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH -rc] KVM: Fix virtualization menu help text
Date: Mon, 17 Sep 2007 11:10:45 +0200
Message-Id: <11900202451420-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What guest drivers?

Cc: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---

An August 18 patch from Jan Engelhardt (06bfb7e) added help text for the virtualization menu.
Unfortunately the text is misleading, as "guest drivers" are usually interpreted to
mean "drivers running inside the guest", which is not the case for kvm.

Linus, please apply.

 drivers/kvm/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 9b72f33..8749fa4 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -6,7 +6,8 @@ menuconfig VIRTUALIZATION
 	depends on X86
 	default y
 	---help---
-	  Say Y here to get to see options for virtualization guest drivers.
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
 	  This option alone does not add any kernel code.
 
 	  If you say N, all options in this submenu will be skipped and disabled.
-- 
1.5.3

