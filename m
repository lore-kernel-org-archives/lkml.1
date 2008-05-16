Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYEPCBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYEPCBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYEPCB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:01:28 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53132 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYEPCB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:01:27 -0400
Subject: [PATCH] Remove duplicate declaration of unknown_nmi_panic
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 16 May 2008 11:01:26 +0900
Message-Id: <1210903286.31993.4.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26-rc2-git4/include/asm-x86/nmi.h linux-2.6.26-rc2-git4-nmi/include/asm-x86/nmi.h
--- linux-2.6.26-rc2-git4/include/asm-x86/nmi.h	2008-05-16 10:35:35.000000000 +0900
+++ linux-2.6.26-rc2-git4-nmi/include/asm-x86/nmi.h	2008-05-16 10:37:25.000000000 +0900
@@ -46,7 +46,6 @@ extern void nmi_watchdog_default(void);
 
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
-extern int unknown_nmi_panic;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);


