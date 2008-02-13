Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYBMV00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYBMV00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYBMV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:26:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:47750 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYBMV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TA1srjELk3uuvGd+WvVQr7IRtYXISDq3zPzbqu37+qCaBPt0Mce2h8qHV580dfMUUsfwEK+F4TfqF6+iWQvIwa2t6PKXQs27jZts/GkVIWt99WGCcAt8BANreUtD3PWGTjRm1oi1gZapBcDHVxfxWuvGGCu1jlxcgSnLC/x0wls=
Subject: [PATCH 1/2] x86: sparse warning in efi.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 13:26:13 -0800
Message-Id: <1202937973.18204.6.camel@brick>
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
index cbdf9ba..0de0cf5 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-struct efi efi_phys __initdata;
+static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
 static int __init setup_noefi(char *arg)
-- 
1.5.4.1.1278.gc75be


