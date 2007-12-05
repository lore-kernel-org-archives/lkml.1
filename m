Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXLETB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXLETB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXLETBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:01:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:33718 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXLETBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=b1xgu15vKrKeFrlr9RVH3ASHVyP+tiWeEKD/dvsJ1kGN5EHdgh3AnrEVg30rVE7nIXeW35eFmRrn2zHd4nrfaQ339ioeMIb37zuOZF8JvODtJBa8ZU5BQ1JrVGBENiGVsJyWKEM7Q94R/lOa8TXOyEDmTtXcVdvgAjOVYa9O8l8=
From: Denis Cheng <crquan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] arch/x86/mm/pageattr_32.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 03:01:00 +0800
Message-Id: <1196881260-18653-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 arch/x86/mm/pageattr_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr_32.c b/arch/x86/mm/pageattr_32.c
index 260073c..f223cc0 100644
--- a/arch/x86/mm/pageattr_32.c
+++ b/arch/x86/mm/pageattr_32.c
@@ -15,7 +15,7 @@
 #include <asm/sections.h>
 
 static DEFINE_SPINLOCK(cpa_lock);
-static struct list_head df_list = LIST_HEAD_INIT(df_list);
+static LIST_HEAD(df_list);
 
 
 pte_t *lookup_address(unsigned long address) 
-- 
1.5.3.4

