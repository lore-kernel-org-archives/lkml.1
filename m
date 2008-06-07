Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbYFGP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbYFGP5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbYFGP4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:56:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:56918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbYFGP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=gvyGXlIaFZWEV0IMic/ijS+RfSGN0NO8dxapsoFTrxFrFB0fUhA+agl74FHSV3ttwh
         Ht4HK22Y9GsmMd+I7t4AZFCiPfFxQ9RBAzj1y++LotiqCIb8PAnGPyrJPggSI2rrSxeY
         8NxTYZC2bdUKRuAbVwb3DAj5wSYpvPJJkpFc8=
References: <20080607155355.010786004@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jun 2008 19:53:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: io-apic - define names for redirection table entry fields
Content-Disposition: inline; filename=x86-io-apic-defs
Message-ID: <484aafc0.0407560a.301e.6a8d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each I/O APIC redirection table entry has a number of fields.
Define names for them to eliminate reference by hard coded
numbers.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/io_apic.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/io_apic.h	2008-06-07 17:09:10.000000000 +0400
+++ linux-2.6.git/include/asm-x86/io_apic.h	2008-06-07 17:55:22.000000000 +0400
@@ -11,6 +11,15 @@
  * Copyright (C) 1997, 1998, 1999, 2000 Ingo Molnar
  */
 
+/* I/O Unit Redirection Table */
+#define IO_APIC_REDIR_VECTOR_MASK	0x000FF
+#define IO_APIC_REDIR_DEST_LOGICAL	0x00800
+#define IO_APIC_REDIR_DEST_PHYSICAL	0x00000
+#define IO_APIC_REDIR_SEND_PENDING	(1 << 12)
+#define IO_APIC_REDIR_REMOTE_IRR	(1 << 14)
+#define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
+#define IO_APIC_REDIR_MASKED		(1 << 16)
+
 /*
  * The structure of the IO-APIC:
  */

-- 
