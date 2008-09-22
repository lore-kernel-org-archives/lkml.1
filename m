Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbYIVJg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbYIVJg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYIVJgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:36:18 -0400
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:42420
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbYIVJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:36:17 -0400
Message-ID: <48D76770.9000808@coritel.it>
Date: Mon, 22 Sep 2008 11:37:52 +0200
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] documentation: xip documentation update
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

xip documentation updated
Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-2.6.26.5/Documentation/filesystems/xip.txt.orig	2008-08-20 20:11:37.000000000 +0200
+++ linux-2.6.26.5/Documentation/filesystems/xip.txt	2008-09-22 11:27:46.000000000 +0200
@@ -39,10 +39,11 @@ The block device operation is optional,
 today:
 - dcssblk: s390 dcss block device driver
 
-An address space operation named get_xip_page is used to retrieve reference
-to a struct page. To address the target page, a reference to an address_space,
-and a sector number is provided. A 3rd argument indicates whether the
-function should allocate blocks if needed.
+An address space operation named get_xip_mem is used to retrieve reference
+to a page frame number and a kernel address. To obtain these values a reference
+to an address_space is provided. This function is in charge to assign values to
+the pointers kmem and pfn. The 3rd argument indicates whether the function 
+should allocate blocks if needed.
 
 This address space operation is mutually exclusive with readpage&writepage that
 do page cache read/write operations.



