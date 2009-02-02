Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZBBAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZBBAHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 19:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZBBAHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 19:07:41 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:35978 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZBBAHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 19:07:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=PTx89eaIiuV5LpYs4GJBwIJoI8jXOPlkTVsrn9um4Sy9RcYTCLJDTF0FZx8UMgSqyT
         lCgK9Gbdtn789yCid8XxgA89hIK6Z3Jat7B3Cl0IzddBSXc5H64G3KgG2SzsmttU+tsj
         qbYohPTnxmIUpbf/byQ3DrvoSU9Dzb2VK1AWc=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 1/2] Fix misleading comment in bio.h
Date: Sun,  1 Feb 2009 22:07:30 -0200
Message-Id: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.1.363.g2a3bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment says "remember to add offset!", but the function already adds
it.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 include/linux/bio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 18462c5..0c8e3fb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -440,8 +440,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
 
 #ifdef CONFIG_HIGHMEM
 /*
- * remember to add offset! and never ever reenable interrupts between a
- * bvec_kmap_irq and bvec_kunmap_irq!!
+ * remember never ever reenable interrupts between a bvec_kmap_irq and
+ * bvec_kunmap_irq!
  *
  * This function MUST be inlined - it plays with the CPU interrupt flags.
  */
-- 
1.6.1.1.363.g2a3bd

