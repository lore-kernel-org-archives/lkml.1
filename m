Return-Path: <linux-kernel-owner+w=401wt.eu-S934917AbZAOVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbZAOVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934573AbZAOU7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:59:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934717AbZAOU7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:59:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trailing whitespace in kernel/ptrace.c
X-Fcc: ~/Mail/linus
X-Zippy-Says: My mind is making ashtrays in Dayton....
Message-Id: <20090115205751.B5F6EFC3DD@magilla.sf.frob.com>
Date: Thu, 15 Jan 2009 12:57:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bug me every time I want to touch ptrace.c, nix them.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c9cf48b..8f61ad8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -48,7 +48,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 	list_add(&child->ptrace_entry, &new_parent->ptraced);
 	child->parent = new_parent;
 }
- 
+
 /*
  * Turn a tracing stop into a normal stop now, since with no tracer there
  * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
@@ -283,7 +283,7 @@ int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst
 		copied += retval;
 		src += retval;
 		dst += retval;
-		len -= retval;			
+		len -= retval;
 	}
 	return copied;
 }
@@ -308,7 +308,7 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 		copied += retval;
 		src += retval;
 		dst += retval;
-		len -= retval;			
+		len -= retval;
 	}
 	return copied;
 }
