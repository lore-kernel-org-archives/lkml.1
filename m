Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZGXH5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZGXH5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZGXH5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:57:31 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55198 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbZGXH5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:57:31 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 1/2] x86: Export kmap_atomic_prot() needed for TTM.
Date: Fri, 24 Jul 2009 09:57:33 +0200
Message-Id: <1248422254-32193-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functionality is needed to kmap_atomic() highmem pages that may
potentially have or are about to set up other mappings with
non-standard caching attributes.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 arch/x86/mm/highmem_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..2112ed5 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -103,6 +103,7 @@ EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_prot);
 
 void __init set_highmem_pages_init(void)
 {
-- 
1.6.1.3

