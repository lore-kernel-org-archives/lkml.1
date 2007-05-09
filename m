Return-Path: <linux-kernel-owner+w=401wt.eu-S1034074AbXEID2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1034074AbXEID2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967560AbXEID2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:28:16 -0400
Received: from ozlabs.org ([203.10.76.45]:44256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967531AbXEID2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:28:15 -0400
Date: Wed, 9 May 2007 13:28:11 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Remove an unused variable from get_unmapped_area()
Message-ID: <20070509032811.GI4198@localhost.localdomain>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@osdl.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent changes in get_unmapped_area() have left the 'ret'
local unused.  This patch removes it.

Signed-off-by: David Gibson <dwg@au1.ibm.com>

Index: working-2.6/mm/mmap.c
===================================================================
--- working-2.6.orig/mm/mmap.c	2007-05-09 13:26:33.000000000 +1000
+++ working-2.6/mm/mmap.c	2007-05-09 13:26:47.000000000 +1000
@@ -1366,7 +1366,6 @@ unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
-	unsigned long ret;
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
