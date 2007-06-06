Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXFFPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXFFPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbXFFPXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:23:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923AbXFFPXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:23:07 -0400
Date: Wed, 6 Jun 2007 11:23:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fix typo in prefetch.h
Message-ID: <20070606152301.GA4619@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index fc86f27..1adfe66 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -27,7 +27,7 @@
 	
 	prefetch(x)  	- prefetches the cacheline at "x" for read
 	prefetchw(x)	- prefetches the cacheline at "x" for write
-	spin_lock_prefetch(x) - prefectches the spinlock *x for taking
+	spin_lock_prefetch(x) - prefetches the spinlock *x for taking
 	
 	there is also PREFETCH_STRIDE which is the architecure-prefered 
 	"lookahead" size for prefetching streamed operations.

-- 
http://www.codemonkey.org.uk
