Return-Path: <linux-kernel-owner+w=401wt.eu-S938091AbXHIAeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938091AbXHIAeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936961AbXHIAeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:34:18 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:35151 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936454AbXHIAeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:34:17 -0400
Message-Id: <20070809003343.310187242@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 20:32:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 2/7] Added generic lg.h in lguest directory.
Content-Disposition: inline; filename=0002-Added-generic-lg.h-in-lguest-directory.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic lg.h file to call the architecture specific one.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/lguest/lg.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
new file mode 100644
index 0000000..4c4356e
--- /dev/null
+++ b/drivers/lguest/lg.h
@@ -0,0 +1,3 @@
+#ifdef CONFIG_X86_32
+#include "i386/lg.h"
+#endif
-- 
1.4.4.4

-- 
