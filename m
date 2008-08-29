Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYH2Ltc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYH2Ltc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYH2LtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:49:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13836 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYH2LtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:49:23 -0400
Message-Id: <48B7FEAE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:50:38 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust dependencies for CONFIG_X86_CMOV
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc5/arch/x86/Kconfig.cpu	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc5-x86-kconfig-cmov/arch/x86/Kconfig.cpu	2008-08-22 15:24:33.000000000 +0200
@@ -403,7 +403,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int



