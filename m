Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbYBMVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbYBMVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764187AbYBMVbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55745 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761923AbYBMVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:04 -0500
Date: Wed, 13 Feb 2008 23:30:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove mca_is_adapter_used()
Message-ID: <20080213213048.GM3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ths patch removes the no longer used mca_is_adapter_used().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 30 Jan 2008

 drivers/mca/mca-legacy.c   |   18 ------------------
 include/linux/mca-legacy.h |    1 -
 2 files changed, 19 deletions(-)

01394d584c7eed507d80eaa881be33512d350851 
diff --git a/drivers/mca/mca-legacy.c b/drivers/mca/mca-legacy.c
index 0c7bfa7..494f0c2 100644
--- a/drivers/mca/mca-legacy.c
+++ b/drivers/mca/mca-legacy.c
@@ -282,24 +282,6 @@ void mca_set_adapter_name(int slot, char* name)
 EXPORT_SYMBOL(mca_set_adapter_name);
 
 /**
- *	mca_is_adapter_used - check if claimed by driver
- *	@slot:	slot to check
- *
- *	Returns 1 if the slot has been claimed by a driver
- */
-
-int mca_is_adapter_used(int slot)
-{
-	struct mca_device *mca_dev = mca_find_device_by_slot(slot);
-
-	if(!mca_dev)
-		return 0;
-
-	return mca_device_claimed(mca_dev);
-}
-EXPORT_SYMBOL(mca_is_adapter_used);
-
-/**
  *	mca_mark_as_used - claim an MCA device
  *	@slot:	slot to claim
  *	FIXME:  should we make this threadsafe
diff --git a/include/linux/mca-legacy.h b/include/linux/mca-legacy.h
index f2bb770..7a3aea8 100644
--- a/include/linux/mca-legacy.h
+++ b/include/linux/mca-legacy.h
@@ -34,7 +34,6 @@
 extern int mca_find_adapter(int id, int start);
 extern int mca_find_unused_adapter(int id, int start);
 
-extern int mca_is_adapter_used(int slot);
 extern int mca_mark_as_used(int slot);
 extern void mca_mark_as_unused(int slot);
 

