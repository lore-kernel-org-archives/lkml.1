Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbZHZKmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbZHZKmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbZHZKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/47] x86: Export kmap_atomic_to_page()
Date: Wed, 26 Aug 2009 13:29:33 +0300
Message-Id: <1251282609-12835-12-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by KVM.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/mm/highmem_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 2112ed5..572f47c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -104,6 +104,7 @@ EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
 EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_to_page);
 
 void __init set_highmem_pages_init(void)
 {
-- 
1.6.4.1

