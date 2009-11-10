Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZKJT6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZKJT6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZKJT6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:58:31 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757957AbZKJT6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:58:30 -0500
Date: Tue, 10 Nov 2009 13:58:35 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Remove asm/apicnum.h
Message-ID: <20091110195835.GA4393@sgi.com>
References: <20091110190515.GB5881@lenovo> <4AF9BBB8.8010809@sgi.com> <20091110192454.GB3904@sgi.com> <20091110192852.GD5881@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110192852.GD5881@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't look as though arch/x86/include/asm/apicnum.h is referenced
anywhere anymore.  Its definitions appear in apicdef.h.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/include/asm/apicnum.h |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux/arch/x86/include/asm/apicnum.h
===================================================================
--- linux.orig/arch/x86/include/asm/apicnum.h	2009-11-10 08:52:08.000000000 -0600
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,12 +0,0 @@
-#ifndef _ASM_X86_APICNUM_H
-#define _ASM_X86_APICNUM_H
-
-/* define MAX_IO_APICS */
-#ifdef CONFIG_X86_32
-# define MAX_IO_APICS 64
-#else
-# define MAX_IO_APICS 128
-# define MAX_LOCAL_APIC 32768
-#endif
-
-#endif /* _ASM_X86_APICNUM_H */
