Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXLMJep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXLMJep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXLMJeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:34:37 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32334
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbXLMJeh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:34:37 -0500
Message-Id: <47610AF1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:35:29 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: set X86_CMOV for all targets using -march=i686
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc5/arch/x86/Kconfig.cpu	2007-12-12 11:28:17.000000000 +0100
+++ 2.6.24-rc5-x86-cmov/arch/x86/Kconfig.cpu	2007-12-04 16:11:19.000000000 +0100
@@ -390,7 +390,7 @@ config X86_TSC
 # generates cmov.
 config X86_CMOV
 	bool
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON)
 	default y
 
 config X86_MINIMUM_CPU_FAMILY



