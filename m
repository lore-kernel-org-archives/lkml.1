Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYE0X3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYE0X3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYE0X3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:29:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:41297 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYE0X3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eGygMj6bX0fxBcpdANWxuRYYFCD1zfXWyZPdAKzkuNAOEr08DoHdb3E/EsBEqLbW/dQQjazHU6n22STeipcux5l8m5D324cfTjrdDIiHAO5crYJd9AgNs/get0U8ImPLUIjr7bD1iRuYvIFO8/DzPzhyjd8boTI4hymza0IKD2g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: remove duplicated e820 func in setup.h
Date: Tue, 27 May 2008 16:29:20 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271629.20629.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we already have them in e820.h

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index ffa0f54..53ef090 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -50,15 +50,9 @@ extern struct boot_params boot_params;
  */
 #define LOWMEMSIZE()	(0x9f000)
 
-struct e820entry;
-
 char * __init machine_specific_memory_setup(void);
 char *memory_setup(void);
 
-int __init copy_e820_map(struct e820entry *biosmap, int nr_map);
-void __init add_memory_region(unsigned long long start,
-			      unsigned long long size, int type);
-
 extern unsigned long init_pg_tables_end;
 
 
