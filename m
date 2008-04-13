Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYDMSQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYDMSQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYDMSQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:27 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54143 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYDMSQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:25 -0400
Date: Sun, 13 Apr 2008 21:15:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct mpt_proc_root_dir static
Message-ID: <20080413181525.GC2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct mpt_proc_root_dir static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/message/fusion/mptbase.c |    3 +--
 drivers/message/fusion/mptbase.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

0206a6da1d1b4ca0e1eb7f6e34ced21c79d58c7b diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index c6be6eb..7e4e69e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -103,7 +103,7 @@ static int mfcounter = 0;
  *  Public data...
  */
 
-struct proc_dir_entry *mpt_proc_root_dir;
+static struct proc_dir_entry *mpt_proc_root_dir;
 
 #define WHOINIT_UNKNOWN		0xAA
 
@@ -7444,7 +7444,6 @@ EXPORT_SYMBOL(mpt_resume);
 EXPORT_SYMBOL(mpt_suspend);
 #endif
 EXPORT_SYMBOL(ioc_list);
-EXPORT_SYMBOL(mpt_proc_root_dir);
 EXPORT_SYMBOL(mpt_register);
 EXPORT_SYMBOL(mpt_deregister);
 EXPORT_SYMBOL(mpt_event_register);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index caadc68..7630031 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -918,7 +918,6 @@ extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhys
  *  Public data decl's...
  */
 extern struct list_head	  ioc_list;
-extern struct proc_dir_entry	*mpt_proc_root_dir;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */

