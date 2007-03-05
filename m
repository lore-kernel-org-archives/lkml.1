Return-Path: <linux-kernel-owner+w=401wt.eu-S933296AbXCEMWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbXCEMWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933383AbXCEMWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:22:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbXCEMWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:22:23 -0500
Date: Mon, 5 Mar 2007 13:13:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch] paravirt: clarify VMI description
Message-ID: <20070305121346.GA14422@elte.hu>
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

Subject: [patch] paravirt: clarify VMI description
From: Ingo Molnar <mingo@elte.hu>

clarify the description of the CONFIG_VMI option: describe the reality 
that VMI is a VMWare-only interface for now. Once that changes and 
another hypervisor adopts the VMI ABI we can change the text. As it can 
be seen from the Xen paravirtualization patches submitted to lkml the 
Xen project has chosen its own, non-VMI interface between Xen and the 
para-Linux - so remove Xen from the description.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -227,8 +227,9 @@ config VMI
 	depends on PARAVIRT
 	default y
 	help
-	  VMI provides a paravirtualized interface to multiple hypervisors
-	  include VMware ESX server and Xen by connecting to a ROM module
+	  VMI provides a paravirtualized interface to the VMware ESX server
+	  (it could be used by other hypervisors in theory too, but is not
+	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
 config ACPI_SRAT
