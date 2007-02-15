Return-Path: <linux-kernel-owner+w=401wt.eu-S966156AbXBOQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156AbXBOQ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966154AbXBOQ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:56:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966150AbXBOQ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:56:17 -0500
Date: Thu, 15 Feb 2007 17:52:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 11/14] syslets: x86: enable ASYNC_SUPPORT
Message-ID: <20070215165248.GL4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

enable CONFIG_ASYNC_SUPPORT on x86.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -38,6 +38,10 @@ config MMU
 	bool
 	default y
 
+config ASYNC_SUPPORT
+	bool
+	default y
+
 config SBUS
 	bool
 
