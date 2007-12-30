Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXL3HSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXL3HSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXL3HLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:13 -0500
Received: from il.qumranet.com ([82.166.9.18]:59493 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 20/52] KVM: Add missing #include <asm/pgtable.h>
Date: Sun, 30 Dec 2007 09:10:06 +0200
Message-Id: <1198998638-22713-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for empty_zero_page.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 469e6b4..d6c5191 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -46,6 +46,7 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
-- 
1.5.3.7

