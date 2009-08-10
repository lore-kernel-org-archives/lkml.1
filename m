Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZHJIQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZHJIQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZHJIQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:16:23 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53813 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZHJIQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:16:23 -0400
Date: Mon, 10 Aug 2009 10:16:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [Patch/RFC 4/4] spinlock: allow inline spinlocks on s390
Message-ID: <20090810081612.GD31234@osiris.boeblingen.de.ibm.com>
References: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select HAVE_KRETPROBES
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_SPINLOCK_INLINE_SUPPORT
 	select INIT_ALL_POSSIBLE
 	select HAVE_PERF_COUNTERS
 	select GENERIC_ATOMIC64 if !64BIT
