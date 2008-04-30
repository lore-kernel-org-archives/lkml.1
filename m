Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYD3DNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYD3DNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYD3DNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:13:04 -0400
Received: from xenotime.net ([66.160.160.81]:47224 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751277AbYD3DNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:13:04 -0400
Date: Tue, 29 Apr 2008 20:13:00 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: jens.axboe@oracle.com, akpm@linux-foundation.org
Subject: [PATCH] docbook: fix bio missing parameter
Message-ID: <Pine.LNX.4.64.0804292012140.18219@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/bio.c kernel-doc parameter warning:
Warning(linux-2.6.25-git14//fs/bio.c:972): No description found for parameter 'reading'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/bio.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.25-git14.orig/fs/bio.c
+++ linux-2.6.25-git14/fs/bio.c
@@ -963,6 +963,7 @@ static void bio_copy_kern_endio(struct b
  *	@data: pointer to buffer to copy
  *	@len: length in bytes
  *	@gfp_mask: allocation flags for bio and page allocation
+ *	@reading: data direction is READ
  *
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
