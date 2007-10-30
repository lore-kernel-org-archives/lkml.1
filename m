Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXJ3Jbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXJ3Jbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXJ3Jbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:31:36 -0400
Received: from nic2.axis.se ([193.13.178.10]:39900 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbXJ3Jbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:31:35 -0400
Date: Tue, 30 Oct 2007 10:31:25 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093125.GJ11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Include linux/fs.h, needed for do_pipe.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 sys_cris.c |    1 +
 1 file changed, 1 insertion(+)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/kernel/sys_cris.c linux-2.6.23/arch/cris/kernel/sys_cris.c
--- clean_linux-2.6.23/arch/cris/kernel/sys_cris.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/kernel/sys_cris.c	2007-10-22 13:39:19.000000000 +0200
@@ -13,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
