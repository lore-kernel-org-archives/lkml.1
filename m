Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXJ3J2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXJ3J2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJ3J2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:28:25 -0400
Received: from nic2.axis.se ([193.13.178.10]:48920 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXJ3J2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:28:24 -0400
Date: Tue, 30 Oct 2007 10:28:11 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/16] CRIS architecture: Correct compile errors
Message-ID: <20071030092811.GD11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove include of asm/bitops.h, not needed here, corrects compilation error
(__le64 undefined).

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 posix_types.h |    1 -
 1 file changed, 1 deletion(-)

--- clean_linux-2.6.23/include/asm-cris/posix_types.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/posix_types.h	2007-10-25 11:32:56.000000000 +0200
@@ -52,7 +52,6 @@
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
-#include <asm/bitops.h>
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
