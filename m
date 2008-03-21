Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYCUNef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYCUNef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYCUNe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:34:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36921 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196AbYCUNe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:34:26 -0400
Date: Fri, 21 Mar 2008 08:34:25 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, ak@suse.de, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Allow NODES_SHIFT to be a config option on x86_64
Message-ID: <20080321133425.GA11095@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the maximum number of nodes in an x86_64 system to
be configurable. This patch does NOT change the default value
but allows the value to be a config option.


	Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2008-03-18 08:11:19.000000000 -0500
+++ linux/arch/x86/Kconfig	2008-03-18 08:23:35.000000000 -0500
@@ -905,7 +905,7 @@ config NUMA_EMU
 	  number of nodes. This is only useful for debugging.
 
 config NODES_SHIFT
-	int
+	int "Max num nodes shift(1-15)"
 	range 1 15  if X86_64
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
