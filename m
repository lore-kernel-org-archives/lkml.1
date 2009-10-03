Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZJCCah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZJCCah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbZJCCag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:30:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZJCCag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:30:36 -0400
Date: Sat, 3 Oct 2009 04:30:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jcm@jonmasters.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [NEXT] Remove "default m" from hardware latency detector
Message-ID: <20091003023038.GA28521@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this while doing make oldconfig on today's linux-next
default ms are usually wrong.

---

No reason at all why this should be default anything except n.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/misc/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 040765f..fe60d8d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -80,7 +80,6 @@ config HWLAT_DETECTOR
 	tristate "Testing module to detect hardware-induced latencies"
 	depends on DEBUG_FS
 	depends on RING_BUFFER
-	default m
 	---help---
 	  A simple hardware latency detector. Use this module to detect
 	  large latencies introduced by the behavior of the underlying
-- 
1.6.0.2


-- 
ak@linux.intel.com -- Speaking for myself only.
