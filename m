Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXIQIdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXIQIdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXIQIcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:45226 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXIQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 003/104] KVM: Future-proof the exit information union ABI
Date: Mon, 17 Sep 2007 10:30:45 +0200
Message-Id: <1190017946675-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Note that as the size of struct kvm_run is not part of the ABI, we can add
things at the end.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index e6edca8..b9a4b7c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -111,6 +111,8 @@ struct kvm_run {
 			__u32 longmode;
 			__u32 pad;
 		} hypercall;
+		/* Fix the size of the union. */
+		char padding[256];
 	};
 };
 
-- 
1.5.3

