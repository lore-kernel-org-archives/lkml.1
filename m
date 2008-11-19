Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYKSNRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYKSNRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYKSNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:16:42 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:52375 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYKSNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=sgksrkHiO1h7Xczn5nBC7/7Mg0/HM7udF1Af8yQCHtEN2aDd+cWpfs5LkOBuyCo5fP
         DbeUFEa5ZOOnTuA49AAnUh4BYukdZlbvdRMU7dFjQywVmvmckBgTF5y7hQRJmD4PC+qu
         WlNbGU2gYF1Hhk6xaea5vxcQ2WjYPmhzilDms=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mike Lavender <mike@steroidmicros.com>,
       David Hinds <dahinds@users.sourceforge.net>
Subject: [PATCH 4/4] drivers/mtd/ftl.c: mark {__init|__exit} for {init|exit}
 functions
Date: Wed, 19 Nov 2008 21:16:33 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492411b7.0c636e0a.1c92.ffffe107@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 9bf581c..c3bbf38 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1099,7 +1099,7 @@ static struct mtd_blktrans_ops ftl_tr = {
 	.owner		= THIS_MODULE,
 };
 
-static int init_ftl(void)
+static int __init init_ftl(void)
 {
 	return register_mtd_blktrans(&ftl_tr);
 }

