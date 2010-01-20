Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729Ab0ATW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0ATW3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594Ab0ATW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:29:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab0ATW3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:29:12 -0500
Date: Wed, 20 Jan 2010 17:29:10 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [PATCH] staging/crystalhd: fix build on powerpc
Message-ID: <20100120222910.GA9498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Airlie <airlied@redhat.com>
Date: Wed, 20 Jan 2010 15:38:58 -0500
Subject: staging/crystalhd: fix build on powerpc

Add necessary include to fix build on PowerPC

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index d3f9fc4..d338ae9 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
+#include <linux/vmalloc.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
-- 
1.6.5.2

-- 
Jarod Wilson
jarod@redhat.com

