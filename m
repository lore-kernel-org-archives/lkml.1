Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZBTIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZBTIDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZBTIDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:03:21 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:37367 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753746AbZBTIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:03:20 -0500
X-YMail-OSG: aak2yb8VM1lPhm0D3650InswpbpRKhjsX66U2beF71FaB7NWM.bDBDQCb8YB5YFD9d89Z8jQQ58XvprMT9YYvulQcj_sAC4dYwLU.y9gEWM9o_TaWeuOusgY9Nh0wEhU7zml1tkUqMK87UFo.0zH5EXxhmzLQhV_CYILdXD8ADi97tC60LjL0fN3L4Lh4F1jIPdeIvaYydME26EZ9lkOxbEyH2H4visw8uXkGLgnCYxb_W5gb18-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/7] [Target_Core_Mod]: Add div64.o to Makefile for
	target_core_mod
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 00:02:14 -0800
Message-Id: <1235116934.12375.1039.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f0f3bddaacec544925e72feffb3be1314817c7f9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:35:28 -0800
Subject: [PATCH 3/7] [Target_Core_Mod]: Add div64.o to Makefile for target_core_mod

Add div64.o for __udivdi3() and __umoddi3() to target_core_mod modules objects.
This is now required for FILEIO and RAMDISK subsystem plugins to calculate total
sector/block count from struct file in BYTES and RAMDISK in PAGE_COUNT respectively.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index 0b222cf..a171db3 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -40,6 +40,7 @@ target_core_mod-objs			:=	target_core_configfs.o \
 						target_core_tmr.o \
 						target_core_tpg.o \
 						target_core_transport.o \
+						div64.o
 
 ifeq ($(LINUX_IBLOCK), 1)
 target_core_mod-objs			+=	target_core_iblock.o
-- 
1.5.4.1



