Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZEAOnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZEAOnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZEAOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35261 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbZEAOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:11 -0400
Subject: [RFC][PATCH 05/35] avr32: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:09 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144209.AC7F0065@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/avr32/include/asm/ptemap.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN /dev/null arch/avr32/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/avr32/include/asm/ptemap.h	2009-04-30 15:10:55.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _AVR32_ASM_PTEMAP_H
+#define _AVR32_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#endif /* _AVR32_ASM_PTEMAP_H */
_
