Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXCEMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXCEMYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933383AbXCEMYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:24:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbXCEMYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:24:17 -0500
Date: Mon, 5 Mar 2007 13:15:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch] paravirt: let users decide whether they want VMI
Message-ID: <20070305121540.GA15710@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] paravirt: let users decide whether they want VMI
From: Ingo Molnar <mingo@elte.hu>

do not use default=y for CONFIG_VMI (we do not do that for any driver or 
special-hardware feature): the overwhelming majority of Linux users does 
not need it, and interested users and distributions can enable it 
as-needed.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -225,7 +225,6 @@ config PARAVIRT
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT
-	default y
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
