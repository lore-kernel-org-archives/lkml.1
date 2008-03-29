Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbYC2DNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbYC2DNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbYC2DKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50240 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235AbYC2DKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:39 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] powerpc/pseries/xcis: ansify
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <E1JfRSo-00030J-LV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/pseries/xics.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index ca52b58..a977f20 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -763,7 +763,7 @@ void xics_request_IPIs(void)
 }
 #endif /* CONFIG_SMP */
 
-void xics_teardown_cpu()
+void xics_teardown_cpu(void)
 {
 	int cpu = smp_processor_id();
 
-- 
1.5.3.GIT


