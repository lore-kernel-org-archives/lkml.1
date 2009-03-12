Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZCLKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZCLKvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZCLKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:51:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32869 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZCLKvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:51:21 -0400
Message-Id: <49B8F761.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:52:01 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: also limit NODES_HIGH_SHIFT here
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.29-rc7/arch/x86/Kconfig	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-i386-nodes-shift-limit/arch/x86/Kconfig	2009-03-06 10:24:22.000000000 +0100
@@ -1087,7 +1087,7 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 9   if X86_64
+	range 1 9
 	default "9" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ



