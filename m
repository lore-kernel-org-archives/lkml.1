Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYD0XQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYD0XQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762951AbYD0XQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:16:04 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:61965 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbYD0XQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:16:03 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: add proper header for reboot_force
Date: Mon, 28 Apr 2008 03:15:59 +0400
Message-Id: <1209338159-30095-3-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes one sparse warning by including the appropriate
header for the reboot_force symbol.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/reboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 69858e8..5ed6cc9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -9,6 +9,7 @@
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgtable.h>
+#include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 
-- 
1.5.3.6

