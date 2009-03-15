Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZCOUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZCOUrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbZCOUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:47:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:54305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZCOUrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:47:08 -0400
Date: Sun, 15 Mar 2009 20:45:52 GMT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090315151517.GA29074@localhost.localdomain>
References: <20090315151517.GA29074@localhost.localdomain>
Subject: [tip:x86/mm] x86, mm: remove unnecessary include file from iomap_32.c
Message-ID: <tip-0920dce7d5889634faa336f65833ee44f3b7651e@git.kernel.org>
Git-Commit-ID: 0920dce7d5889634faa336f65833ee44f3b7651e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 15 Mar 2009 20:45:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0920dce7d5889634faa336f65833ee44f3b7651e
Gitweb:     http://git.kernel.org/tip/0920dce7d5889634faa336f65833ee44f3b7651e
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Mon, 16 Mar 2009 00:15:18 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Mar 2009 20:05:08 +0100

x86, mm: remove unnecessary include file from iomap_32.c

asm/highmem.h inclusion is added to use kmap_atomic_prot_pfn()
by commit bb6d59ca927d855ffac567b35c0a790c67016103

Now kmap_atomic_prot_pfn is moved to iomap_32.c
by commit dd63fdcc63f0f853b116b52e56200a0e0227cf5f

So the asm/highmem.h inclusion in iomap_32.c is unnecessary now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090315151517.GA29074@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/iomap_32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 6e60ba6..699c9b2 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -18,7 +18,6 @@
 
 #include <asm/iomap.h>
 #include <asm/pat.h>
-#include <asm/highmem.h>
 #include <linux/module.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
