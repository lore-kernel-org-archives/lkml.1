Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbYBEUoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbYBEUoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761054AbYBEUnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:43:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:21269 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbYBEUnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=evgTeUZihwMSQtFDBCaRv6MQxRD2+ZQ9n1QkBpaxS+tILnyV/Pg+o9HqQOu0GCKa9x4VnQPAG7JMtFKmlN/XK4fsNfByBt9UjZcl277otUsqiRPwcK38bFhy451yzQblH2ivhdGoOvej3P/PjHbIXi9uqwPim5psOpiQyuPL1ds=
Subject: [PATCH 7/8] x86: fix sparse warning in topology.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:42:49 -0800
Message-Id: <1202244172.18081.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/topology.c:56:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/topology.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index e6757aa..a40051b 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL(arch_register_cpu);
 
 void arch_unregister_cpu(int num)
 {
-	return unregister_cpu(&per_cpu(cpu_devices, num).cpu);
+	unregister_cpu(&per_cpu(cpu_devices, num).cpu);
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
 #else
-- 
1.5.4.rc5.1138.g2602


