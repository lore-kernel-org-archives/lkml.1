Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbXEPNAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbXEPNAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXEPNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:00:41 -0400
Received: from verein.lst.de ([213.95.11.210]:43116 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXEPNAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:00:40 -0400
Date: Wed, 16 May 2007 14:59:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove odd and misleading comments from uio.h
Message-ID: <20070516125959.GB1322@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/uio.h
===================================================================
--- linux-2.6.orig/include/linux/uio.h	2007-01-16 03:40:19.000000000 +0100
+++ linux-2.6/include/linux/uio.h	2007-01-16 03:41:08.000000000 +0100
@@ -13,10 +13,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-
-/* A word of warning: Our uio structure will clash with the C library one (which is now obsolete). Remove the C
-   library one from sys/uio.h if you have a very old library set */
-
 struct iovec
 {
 	void __user *iov_base;	/* BSD uses caddr_t (1003.1g requires void *) */
@@ -38,11 +34,6 @@
  
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
-#if 0
-#define UIO_MAXIOV	16	/* Maximum iovec's in one operation 
-				   16 matches BSD */
-                                /* Beg pardon: BSD has 1024 --ANK */
-#endif
 
 /*
  * Total number of bytes covered by an iovec.
