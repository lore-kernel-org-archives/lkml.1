Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZIZSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZIZSSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZIZSSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:18:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZIZSSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:18:34 -0400
Date: Sat, 26 Sep 2009 20:18:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix CONFIG_NUMA help message
Message-ID: <20090926181837.GA15018@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed recently while looking at this file. The x86 NUMA Kconfig help
entry is not quite correct.

- Core i7 systems are always non NUMA. Refer to multi socket Nehalems instead.
- Replace outdated EM64T term with Intel 64

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 384a897..47c81bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1118,8 +1118,9 @@ config NUMA
 	  local memory controller of the CPU and add some more
 	  NUMA awareness to the kernel.
 
-	  For 64-bit this is recommended if the system is Intel Core i7
-	  (or later), AMD Opteron, or EM64T NUMA.
+	  For 64-bit this is recommended if the system is Intel Xeon 75xx
+	  (Intel Nehalem based multi socket systems), AMD Opteron, or Intel
+          64 NUMA.
 
 	  For 32-bit this is only needed on (rare) 32-bit-only platforms
 	  that support NUMA topologies, such as NUMAQ / Summit, or if you
-- 
1.6.0.2


-- 
ak@linux.intel.com -- Speaking for myself only.
