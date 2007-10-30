Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbXJ3Jaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbXJ3Jaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXJ3JaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:30:18 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36586 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbXJ3JaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:30:16 -0400
Date: Tue, 30 Oct 2007 10:30:00 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093000.GG11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Include asm/irq.h to avoid undefined value warning.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 hardirq.h |    1 +
 1 file changed, 1 insertion(+)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/hardirq.h linux-2.6.23/include/asm-cris/hardirq.h
--- clean_linux-2.6.23/include/asm-cris/hardirq.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/hardirq.h	2007-10-22 10:35:12.000000000 +0200
@@ -1,6 +1,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
+#include <asm/irq.h>
 #include <linux/threads.h>
 #include <linux/cache.h>
 
/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
