Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbYBGAii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbYBGAii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbYBGAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:07:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33142 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbYBGAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BVN10Ka4uSwURcWgm0v2J5MQ+9sOahp/1nDREmMI6QUeUIUJaGNZmZElUNhaU8EhNoaz6bS83cpPhmySEkXwlfvPHIKRyxwJHiPgpfjANQGTsNNdCwKPWqEt2klD4WQOAolLsgLnYGpo5r8zX7rAQcRDeMgCDXnrlvBEyKvWcdM=
Subject: [PATCH 2/3] x86: sparse warning in efi.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 16:07:48 -0800
Message-Id: <1202342868.5820.90.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/efi.c:57:12: warning: symbol 'efi_phys' was not declared. Should it be static?

Yes, it should.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 32dd62b..43022d6 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-struct efi efi_phys __initdata;
+static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
 static int __init setup_noefi(char *arg)
-- 
1.5.4.1189.g38fd5


