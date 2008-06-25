Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYFYEja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYFYEja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYFYEhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:15 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37441 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753035AbYFYEhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 36] x86_64: add prototype for x86_64_start_kernel()
X-Mercurial-Node: 360c682ea70574f0fe0a68a3f2fc30d077686452
Message-Id: <360c682ea70574f0fe0a.1214367549@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/setup.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -61,6 +61,8 @@
 extern unsigned long init_pg_tables_start;
 extern unsigned long init_pg_tables_end;
 
+#else
+void __init x86_64_start_kernel(char *real_mode);
 #endif /* __i386__ */
 #endif /* _SETUP */
 #endif /* __ASSEMBLY__ */


