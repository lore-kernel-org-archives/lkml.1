Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYAOV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYAOV5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYAOV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:56:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63081 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYAOV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:56:48 -0500
Date: Tue, 15 Jan 2008 13:56:27 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/4] x86: msr for AMD Fam 10h mmio
In-reply-to: <200801151354.02859.yinghai.lu@sun.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801151356.27779.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801141331.45898.yinghai.lu@sun.com>
 <478CD46D.5080104@zytor.com> <200801151354.02859.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: msr for AMD Fam 10h mmio

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index f9c1453..c3237ff 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -96,6 +96,14 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 
+/* Fam 10h MSRs */
+#define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
+#define FAM10H_MMIO_CONF_ENABLE		(1<<0)
+#define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
+#define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
+#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
+#define FAM10H_MMIO_CONF_BASE_SHIFT	20
+
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
