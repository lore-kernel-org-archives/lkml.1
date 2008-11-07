Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYKGWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYKGWJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYKGWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:08:58 -0500
Received: from xenotime.net ([72.52.64.118]:37165 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751959AbYKGWI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:08:57 -0500
Date: Fri, 7 Nov 2008 14:08:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Marco Stornelli <marco.stornelli@gmail.com>,
       Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH] DOC: update xip method info
Message-Id: <20081107140823.6361f21e.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

xip documentation updated:
- change "get_xip_page" to "get_xip_mem";
- explain changed function parameters

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
cc: Carsten Otte <cotte@de.ibm.com>
---
 Documentation/filesystems/xip.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-next-20081107.orig/Documentation/filesystems/xip.txt
+++ linux-next-20081107/Documentation/filesystems/xip.txt
@@ -39,10 +39,11 @@ The block device operation is optional, 
 today:
 - dcssblk: s390 dcss block device driver
 
-An address space operation named get_xip_page is used to retrieve reference
-to a struct page. To address the target page, a reference to an address_space,
-and a sector number is provided. A 3rd argument indicates whether the
-function should allocate blocks if needed.
+An address space operation named get_xip_mem is used to retrieve references
+to a page frame number and a kernel address. To obtain these values a reference
+to an address_space is provided. This function assigns values to the kmem and
+pfn parameters. The third argument indicates whether the function should allocate
+blocks if needed.
 
 This address space operation is mutually exclusive with readpage&writepage that
 do page cache read/write operations.
