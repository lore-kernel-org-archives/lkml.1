Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0BQMLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:11:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:48239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0BQMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:11:21 -0500
Date: Wed, 17 Feb 2010 12:10:27 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100215113241P.fujita.tomonori@lab.ntt.co.jp>
References: <20100215113241P.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86/gart: Unexport gart_iommu_aperture
Message-ID: <tip-c13f3d378f77ce3176628ade452b0e461242faf3@git.kernel.org>
Git-Commit-ID: c13f3d378f77ce3176628ade452b0e461242faf3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 12:10:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c13f3d378f77ce3176628ade452b0e461242faf3
Gitweb:     http://git.kernel.org/tip/c13f3d378f77ce3176628ade452b0e461242faf3
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 15 Feb 2010 11:33:04 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Feb 2010 22:05:09 +0100

x86/gart: Unexport gart_iommu_aperture

I wrongly exported gart_iommu_aperture in the commit
42590a75019a50012f25a962246498dead428433. It's not necessary so
let's unexport it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20100215113241P.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/aperture_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index f147a95..3704997 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -31,7 +31,6 @@
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
-EXPORT_SYMBOL_GPL(gart_iommu_aperture);
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
 
