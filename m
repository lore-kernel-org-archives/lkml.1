Return-Path: <linux-kernel-owner+w=401wt.eu-S965038AbXAZLif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965038AbXAZLif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXAZLif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:38:35 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:29689 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933204AbXAZLie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:38:34 -0500
Subject: Re: [PATCH 00/09] atomic.h : standardizing atomic primitives
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Jeff Dike <jdike@addtoit.com>
In-Reply-To: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jan 2007 11:06:42 +0100
Message-Id: <1169806002.6189.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 11:15 -0500, Mathieu Desnoyers wrote:
> atomic.h : standardizing atomic primitives
> 
> It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
> unless. Therefore, principally 64 bits architectures are targeted by these
> patches. It also adds the complete list of atomic operations on the atomic_long
> type.
> 
> These patches apply on 2.6.20-rc5-git4.

ARCH=um SUBARCH=i386

In file included from include2/asm/arch/atomic.h:257,
                 from include2/asm/atomic.h:10,
                 from /usr/src/linux-2.6-git/include/linux/file.h:9,
                 from /usr/src/linux-2.6-git/mm/fadvise.c:12:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function ‘atomic_long_add_unless’:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h:260: warning: implicit declaration of function ‘cmpxchg’
/usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function ‘atomic_long_xchg’:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h:281: warning: implicit declaration of function ‘xchg’


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/asm-um/atomic.h b/include/asm-um/atomic.h
index b683f10..b2766b0 100644
--- a/include/asm-um/atomic.h
+++ b/include/asm-um/atomic.h
@@ -6,6 +6,7 @@ #define __UM_ATOMIC_H
  */
 #include "linux/kernel.h"
 
+#include "asm/arch/system.h"
 #include "asm/arch/atomic.h"
 
 #endif


