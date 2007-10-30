Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXJ3Jgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXJ3Jgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXJ3JfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:35:18 -0400
Received: from nic2.axis.se ([193.13.178.10]:39942 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbXJ3JfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:35:16 -0400
Date: Tue, 30 Oct 2007 10:35:05 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093505.GQ11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/param.h for HZ.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/arch-v10/kernel/setup.c linux-2.6.23/arch/cris/arch-v10/kernel/setup.c
--- clean_linux-2.6.23/arch/cris/arch-v10/kernel/setup.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/kernel/setup.c	2007-10-22 13:53:03.000000000 +0200
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_PROC_FS
 #define HAS_FPU		0x0001

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
