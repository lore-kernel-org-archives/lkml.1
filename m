Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYKEWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYKEWSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYKEWSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:18:23 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:39318 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYKEWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:18:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=bcHM9T+7xXaa7fkvnoec2/bLngSDKOpqO/g21Z/qgkJ9h6kbxV8XTP5K5lFLG2+8WtWQCiST0NVY0MoVl9UQrPu7tKPjhnr06QvcVEKnOlX+YKSchNtSLSMnJg0FsJmT;
Message-ID: <49121BAB.3030403@simon.arlott.org.uk>
Date: Wed, 05 Nov 2008 22:18:19 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: trivial@kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Kconfig: SLUB is the default slab allocator
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2007, a0acd820807680d2ccc4ef3448387fcdbf152c73 changed the default 
slab allocator to SLUB, but the SLAB help text still says SLAB is the 
default. This change fixes that.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 init/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 86b00c5..226da27 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -771,8 +771,7 @@ config SLAB
 	help
 	  The regular slab allocator that is established and known to work
 	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues. SLAB is the default choice for
-	  a slab allocator.
+	  per cpu and per node queues.
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
@@ -781,7 +780,8 @@ config SLUB
 	   instead of managing queues of cached objects (SLAB approach).
 	   Per cpu caching is realized using slabs of objects instead
 	   of queues of objects. SLUB can use memory efficiently
-	   and has enhanced diagnostics.
+	   and has enhanced diagnostics. SLUB is the default choice for
+	   a slab allocator.
 
 config SLOB
 	depends on EMBEDDED
-- 
1.6.0.3

-- 
Simon Arlott
