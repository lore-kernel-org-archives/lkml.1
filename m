Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYDARZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYDARZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYDARZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:25:34 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:44795 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYDARZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:25:33 -0400
Message-ID: <47F26FF6.8070300@tiscali.nl>
Date: Tue, 01 Apr 2008 19:25:10 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru
CC: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] alpha: replace `__attribute' by `__attribute__'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace `__attribute' by `__attribute__'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/alpha/kernel/core_cia.c b/arch/alpha/kernel/core_cia.c
index 1d6ee6c..0f2df3c 100644
--- a/arch/alpha/kernel/core_cia.c
+++ b/arch/alpha/kernel/core_cia.c
@@ -569,7 +569,7 @@ struct
 	unsigned int w_mask;
 	unsigned int t_base;
     } window[4];
-} saved_config __attribute((common));
+} saved_config __attribute__((common));
 
 void
 cia_save_srm_settings(int is_pyxis)
diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index f5ca525..3e4d908 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -91,7 +91,7 @@ static struct
 	unsigned long hae_3;
 	unsigned long hae_4;
 	unsigned long hbase;
-} t2_saved_config __attribute((common));
+} t2_saved_config __attribute__((common));
 
 /*
  * Given a bus, device, and function number, compute resulting
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index ee7b900..c53a0c2 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -40,7 +40,7 @@
 struct 
 {
 	unsigned int orig_route_tab; /* for SAVE/RESTORE */
-} saved_config __attribute((common));
+} saved_config __attribute__((common));
 #endif
 
 
