Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbXJ3Jaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbXJ3Jaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXJ3Jan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:30:43 -0400
Received: from nic2.axis.se ([193.13.178.10]:48955 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbXJ3Jam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:30:42 -0400
Date: Tue, 30 Oct 2007 10:30:31 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093031.GH11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include file linux/compiler.h is needed for 'likely'.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 atomic.h |    1 +
 1 file changed, 1 insertion(+)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/atomic.h linux-2.6.23/include/asm-cris/atomic.h
--- clean_linux-2.6.23/include/asm-cris/atomic.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/atomic.h	2007-10-22 10:32:54.000000000 +0200
@@ -5,6 +5,7 @@
 
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
+#include <linux/compiler.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
