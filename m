Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXJ3J3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXJ3J3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXJ3J3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:29:08 -0400
Received: from nic2.axis.se ([193.13.178.10]:48928 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbXJ3J3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:29:07 -0400
Date: Tue, 30 Oct 2007 10:28:56 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/16] CRIS architecture: Correct compile errors
Message-ID: <20071030092856.GE11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove int from prototype, no longer needed and causes compile error.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/checksum.h linux-2.6.23/include/asm-cris/checksum.h
--- clean_linux-2.6.23/include/asm-cris/checksum.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/checksum.h	2007-10-22 10:39:08.000000000 +0200
@@ -62,7 +62,7 @@
  * returns a 16-bit checksum, already complemented
  */
 
-static inline __sum16 int csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
 						   unsigned short len,
 						   unsigned short proto,
 						   __wsum sum)

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
