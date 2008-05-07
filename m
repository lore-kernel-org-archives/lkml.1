Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYEGIHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYEGIHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYEGIH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:07:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYEGIHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:07:25 -0400
Message-ID: <482162E5.7030606@cn.fujitsu.com>
Date: Wed, 07 May 2008 16:05:57 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove printk compiling warning
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since size is unsigned long, the format string is changed
from zd to lu.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cc6f5eb..c0c68c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)

 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
 			  size);

 	for_each_possible_cpu(i) {
-- 
1.5.4.1
