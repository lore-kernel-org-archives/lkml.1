Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbYEGOcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbYEGOcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbYEGOcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:32:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYEGOcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:32:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Make cpu_relax() invoke barrier()
To: torvalds@osdl.org, akpm@linux-foundation.org, bhutchings@solarflare.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 07 May 2008 15:31:54 +0100
Message-ID: <20080507143154.16216.80041.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cpu_relax() invoke barrier() to be the same as other arches.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-mn10300/processor.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-mn10300/processor.h b/include/asm-mn10300/processor.h
index f1b081f..7323927 100644
--- a/include/asm-mn10300/processor.h
+++ b/include/asm-mn10300/processor.h
@@ -58,7 +58,7 @@ extern struct mn10300_cpuinfo boot_cpu_data;
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
 extern void dodgy_tsc(void);
-#define cpu_relax() do {} while (0)
+#define cpu_relax() barrier()
 
 /*
  * User space process size: 1.75GB (default).

