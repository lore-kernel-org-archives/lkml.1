Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYHBNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYHBNQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYHBNQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:16:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:3281 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYHBNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=SfNd81SiLJR+30Xj89sQ7luU3PWdBw3jPV0mwMNFatFdX99OoJ2+g1cUIJfo1OsDbq
         ye37kD55nspEN4sx33q4MH2M16GYm9trZvEh3qiHLenOWZMPf/ydbTES+lFZpljAegFU
         /qlDSCiLn/COhsPkPXDRxbMdGOldhqjtiMImM=
Date: Sat, 02 Aug 2008 21:16:02 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: mm/hugetlb.c: removed duplicated #include
Message-Id: <20080802211031.D63E.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both commit 7cb93181629c613ee2b8f4ffe3446f8003074842 and
78a34ae29bf1c9df62a5bd0f0798b6c62a54d520 added #include <asm/io.h> 
in mm/hugetlb.c, but in 2 sightly different places.

This patch fixed it.

Signed-off-by: Huang Weiyi <hwy@cn.fujitsu.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 28a2980..d61b954 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -20,7 +20,6 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/io.h>

 #include <linux/hugetlb.h>
 #include "internal.h"

