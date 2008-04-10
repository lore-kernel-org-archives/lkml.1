Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYDJPAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYDJPAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYDJPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:00:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538AbYDJPA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:00:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] FRV: Move STACK_TOP_MAX up
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 10 Apr 2008 16:00:25 +0100
Message-ID: <20080410150025.30046.4301.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
References: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Move STACK_TOP_MAX up so that we don't try moving the stack above it as that
causes setup_arg_pages() to malfunction.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/mem-layout.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
index 8353225..734a1d0 100644
--- a/include/asm-frv/mem-layout.h
+++ b/include/asm-frv/mem-layout.h
@@ -60,7 +60,7 @@
  */
 #define BRK_BASE			__UL(2 * 1024 * 1024 + PAGE_SIZE)
 #define STACK_TOP			__UL(2 * 1024 * 1024)
-#define STACK_TOP_MAX	STACK_TOP
+#define STACK_TOP_MAX			__UL(0xc0000000)
 
 /* userspace process size */
 #ifdef CONFIG_MMU

