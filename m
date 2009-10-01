Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZJAKAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZJAKAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZJAKAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:00:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:55870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbZJAKAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:00:13 -0400
Date: Thu, 1 Oct 2009 09:58:57 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, jaswinder@kernel.org, mpm@selenic.com,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, rpjday@crashcourse.ca, mingo@elte.hu,
       cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, jaswinder@kernel.org, mpm@selenic.com,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, rpjday@crashcourse.ca, cl@linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <1253981501.4568.61.camel@ht.satnam>
References: <1253981501.4568.61.camel@ht.satnam>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, SLUB: Remove unused CONFIG FAST_CMPXCHG_LOCAL
Message-ID: <tip-4701472e441e41be2549a25228f703bc9cd13b5b@git.kernel.org>
Git-Commit-ID: 4701472e441e41be2549a25228f703bc9cd13b5b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:59:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4701472e441e41be2549a25228f703bc9cd13b5b
Gitweb:     http://git.kernel.org/tip/4701472e441e41be2549a25228f703bc9cd13b5b
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 26 Sep 2009 21:41:41 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 10:59:08 +0200

x86, SLUB: Remove unused CONFIG FAST_CMPXCHG_LOCAL

Remove unused CONFIG FAST_CMPXCHG_LOCAL from Kconfig.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-mm@kvack.org
LKML-Reference: <1253981501.4568.61.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8da9374..c876bac 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -86,10 +86,6 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
-config FAST_CMPXCHG_LOCAL
-	bool
-	default y
-
 config MMU
 	def_bool y
 
