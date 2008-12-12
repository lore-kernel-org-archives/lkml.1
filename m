Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYLLJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYLLJce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbYLLJcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:32:19 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:38020 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758704AbYLLJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:32:18 -0500
X-YMail-OSG: 19hU5nwVM1mfadiqPMC65iTeYe336SkO7Gvgg.gLv_EHYsYAOY3ijXuDwp.t_PSxP38aGQRLPbVtiyiuPaR9PZSZrqcbZj7OS6F85A42O3.htoJC9kRok6_neFqcVMtbY20TtPJ.7.JTBuemPKSPw7O6GLP2quQYEviXa6wnM3nrutVsnkHvw2jQ5og-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [Target_Core_Mod 5/12]: Remove iSCSI includes from
	target_core_seobj.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 01:32:15 -0800
Message-Id: <1229074335.4153.645.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a4acf83dd5857c69d5b76f9ce703e57ff6cf9ba1 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:52:04 -0800
Subject: [PATCH] [Target_Core_Mod]: Remove iSCSI includes from target_core_seobj.c

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_scdb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_scdb.c b/drivers/lio-core/target_core_scdb.c
index 62c3f1b..1ee4266 100644
--- a/drivers/lio-core/target_core_scdb.c
+++ b/drivers/lio-core/target_core_scdb.c
@@ -42,9 +42,6 @@
 #include <iscsi_linux_os.h>
 #include <iscsi_linux_defs.h>
 
-#include <iscsi_lists.h>
-#include <iscsi_protocol.h>
-#include <iscsi_target_core.h>
 #include <target_core_base.h>
 #include <target_core_hba.h>
 #include <target_core_transport.h>
-- 
1.5.4.1



