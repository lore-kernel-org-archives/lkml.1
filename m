Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYDUKcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYDUKcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbYDUKaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:14 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37886
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/31] KVM: s390: Stub out kvmtrace
Date: Mon, 21 Apr 2008 13:29:33 +0300
Message-Id: <1208773797-7829-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 2489b34..1761b74 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -36,6 +36,9 @@ config KVM
 
 	  If unsure, say N.
 
+config KVM_TRACE
+       bool
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/virtio/Kconfig
-- 
1.5.5

