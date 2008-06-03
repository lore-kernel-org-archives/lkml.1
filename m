Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYFCTDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYFCTDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYFCTDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:03:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58505 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYFCTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:03:21 -0400
Date: Tue, 3 Jun 2008 15:02:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/6] UML - Remove a duplicate include
Message-ID: <20080603190236.GA9513@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file "kern_util.h" in 
arch/um/drivers/ubd_kern.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/ubd_kern.c	2008-04-24 13:22:04.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/ubd_kern.c	2008-05-09 11:12:09.000000000 -0400
@@ -49,7 +49,6 @@
 #include "irq_user.h"
 #include "irq_kern.h"
 #include "ubd_user.h"
-#include "kern_util.h"
 #include "os.h"
 #include "mem.h"
 #include "mem_kern.h"
