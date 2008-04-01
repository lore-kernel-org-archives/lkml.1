Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbYDBAAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbYDBAAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbYDAX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:51 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64034 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbYDAX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] [MIPS] unexport rtc_mips_set_time()
Date: Wed,  2 Apr 2008 03:58:37 +0400
Message-Id: <1207094318-21748-5-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users for the rtc_mips_set_time() routine exist outside of the
core kernel code. Therefore, EXPORT_SYMBOL(rtc_mips_set_time) is
useless, and this patch removes it.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/kernel/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index b45a709..d70ce5c 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -38,7 +38,6 @@ int __weak rtc_mips_set_time(unsigned long sec)
 {
 	return 0;
 }
-EXPORT_SYMBOL(rtc_mips_set_time);
 
 int __weak rtc_mips_set_mmss(unsigned long nowtime)
 {
-- 
1.5.3

