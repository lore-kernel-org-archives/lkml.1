Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZEMDP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZEMDP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZEMDG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:27 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36219
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756112AbZEMDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/10] xen/swiotlb: make sure prototypes are in scope for swiotlb functions
Date: Tue, 12 May 2009 14:50:50 -0700
Message-Id: <1242165051-6636-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This makes sure the functions overriding the lib/swiotlb.c weak functions
have the right prototype.

[ Impact: cleanup; better compile checking ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci-swiotlb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index c2850b3..544c0c0 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -1,5 +1,7 @@
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
+#include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
 
 #include <xen/swiotlb.h>
 #include <asm/xen/hypervisor.h>
-- 
1.6.0.6

