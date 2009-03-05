Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZCEKa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZCEKa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZCEKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:30:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCEKaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:30:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=wd+yICVxxiNJ2//SgRUJUOt3K7CglNB6Gf06udJ1fyMXsXoZxHFxWuAlcWTPnNlzh
	3riWGfCIKu2HF4jiWngQQ==
Date: Thu, 5 Mar 2009 02:29:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/2] lockdep: remove duplicate CONFIG_DEBUG_LOCKDEP
 definitions
Message-ID: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic debug modifiers are already defined in
kernel/lockdep_internals.h.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/lockdep.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -430,13 +430,6 @@ atomic_t nr_find_usage_forwards_checks;
 atomic_t nr_find_usage_forwards_recursions;
 atomic_t nr_find_usage_backwards_checks;
 atomic_t nr_find_usage_backwards_recursions;
-# define debug_atomic_inc(ptr)		atomic_inc(ptr)
-# define debug_atomic_dec(ptr)		atomic_dec(ptr)
-# define debug_atomic_read(ptr)		atomic_read(ptr)
-#else
-# define debug_atomic_inc(ptr)		do { } while (0)
-# define debug_atomic_dec(ptr)		do { } while (0)
-# define debug_atomic_read(ptr)		0
 #endif
 
 /*
