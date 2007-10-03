Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXJCBeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXJCBeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXJCBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:34:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42349 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXJCBeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:34:14 -0400
Date: Tue, 2 Oct 2007 21:34:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: ak@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Document x86-64 iommu kernel parameters
Message-ID: <20071003013413.GA17717@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
After having to go figure out what some of these means, I figured I
would save others the trouble.

Some of these are "best guess" based on a quick scan of the code, so it
certainly needs a sanity review before going upstream.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4d175c7..8afea9b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -763,6 +763,30 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	inttest=	[IA64]
 
+	iommu=option[,option..]	[X86-64]
+		off		Disable IOMMU.
+		force		Unconditionally enable IOMMU.
+		noforce		Disable IOMMU and IOMMU merging, by default.
+		biomerge	Unconditionally enable IOMMU, IOMMU merging,
+				and set BIO IOMMU vmerge boundary to 4096.
+		panic		Panic on IOMMU overflow.
+		nopanic		Do not panic on IOMMU overflow.
+		merge		Unconditionally enable IOMMU, IOMMU merging.
+		nomerge		Disable IOMMU merging.
+		forcesac	Force single address cycle (SAC, 32-bit).
+		allowdac	Permit dual address cycle (DAC, 64-bit).
+		nodac		Forbid dual address cycle (DAC, 64-bit).
+		soft		Enable swiotlb.
+		calgary		Use Calgary IOMMU.
+
+			(GART-only options follow...)
+		<NNN>		Specify size of remapping area.
+		fullflush	Disable optimizing flushing strategy.
+		nofullflush	Enable optimizing flushing strategy.
+		noagp		Use entire aperture, AGP isn't using it.
+		noaperture	Disable aperture fixups / hole init.
+		memaper=<N>	malloc an aperture of order N.
+
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
