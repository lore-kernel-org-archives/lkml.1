Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbYD1VmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbYD1VmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbYD1VmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:42:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51762 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbYD1VmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x4kdSd30Ic5MJ/JksGV9xZipSzeNvBhruq2oBpoCgJjF1LgcvaC7YwthXEyt23mlcsWOYGs5GEGba571qV9BLGMhu12stvXySQwQcFx1ZJhhBQMB5kTAL8K+G+PfNlckqLWniJo7j6Hg2SO1n7m4vW35nCQ4F4wQrXJsxuB9Ivw=
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>
Subject: [PATCH] x86: fix return type of detect_vsmp_box() for !CONFIG_PCI
Date: Mon, 28 Apr 2008 23:40:50 +0200
Message-Id: <1209418850-19942-1-git-send-email-bert.wesarg@googlemail.com>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return type for CONFIG_PCI is void, but for !CONFIG_PCI its int.
Fix this.

Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
---
 arch/x86/kernel/vsmp_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index caf2a26..ba8c0b7 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -133,7 +133,7 @@ int is_vsmp_box(void)
 	}
 }
 #else
-static int __init detect_vsmp_box(void)
+static void __init detect_vsmp_box(void)
 {
 }
 int is_vsmp_box(void)
-- 
1.5.5.GIT

