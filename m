Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712Ab0A0UYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0A0UYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655Ab0A0UYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:24:44 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:32839 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0A0UYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TkgVc8rTtTbRYl2mv6IIQ3ITTviimVpzgJDCIDL+HCfZhWMeD6XieFvQvdHw9fqyoj
         EcgjygBQJlK80hoQusDNDJY4Dy7rfS15ynYNbvQE7KjnR+kUdnvDzQ3/h0jTxNZWSS8z
         bo0iBm0Eykmh6x3wwtnZHXsNKJP/wQ/dEkVbQ=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <C.Emde@osadl.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@localhost.localdomain>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 4/5] rt-tests: Fix some style problems, such as spaces instead of tabs.
Date: Wed, 27 Jan 2010 21:24:27 +0100
Message-Id: <1264623868-23595-5-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
References: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur@localhost.localdomain>

Fix some style problems, such as spaces instead of tabs, trailing spaces,
spaces required before }

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 src/cyclictest/rt_numa.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/cyclictest/rt_numa.h b/src/cyclictest/rt_numa.h
index ac2aca2..73ef3d8 100644
--- a/src/cyclictest/rt_numa.h
+++ b/src/cyclictest/rt_numa.h
@@ -40,7 +40,7 @@ threadfree(void *ptr, size_t size, int node)
 		free(ptr);
 	else
 		numa_free(ptr, size);
-}			
+}
 
 static void rt_numa_set_numa_run_on_node(int node, int cpu)
 {
@@ -73,29 +73,29 @@ static int rt_numa_numa_node_of_cpu(int cpu)
 static int rt_numa_numa_node_of_cpu(int cpu)
 {
 	unsigned char cpumask[16];
-        int node, idx, bit;
+	int node, idx, bit;
 	int max_node, max_cpus;
 
 	max_node = numa_max_node();
 	max_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
-        if (cpu > max_cpus) {
-                errno = EINVAL;
-                return -1;
-        }
+	if (cpu > max_cpus) {
+		errno = EINVAL;
+		return -1;
+	}
 
 	/* calculate bitmask index and relative bit position of cpu */
 	idx = cpu / 8;
 	bit = cpu % 8;
 
-        for (node = 0; node <= max_node; node++) {
+	for (node = 0; node <= max_node; node++) {
 		if (numa_node_to_cpus(node, (void *) cpumask, sizeof(cpumask)))
 			return -1;
 
 		if (cpumask[idx] & (1<<bit))
 			return node;
-        }
-        errno = EINVAL;
+	}
+	errno = EINVAL;
 	return -1;
 }
 
@@ -114,10 +114,10 @@ static void *rt_numa_numa_alloc_onnode(size_t size, int node, int cpu)
 #else
 
 static inline void *threadalloc(size_t size, int n) { return malloc(size); }
-static inline void threadfree(void *ptr, size_t s, int n) { free(ptr); } 
+static inline void threadfree(void *ptr, size_t s, int n) { free(ptr); }
 static inline void rt_numa_set_numa_run_on_node(int n, int c) { }
 static inline void numa_on_and_available() { };
-static inline int rt_numa_numa_node_of_cpu(int cpu) { return -1;}
+static inline int rt_numa_numa_node_of_cpu(int cpu) { return -1; }
 static void *rt_numa_numa_alloc_onnode(size_t s, int n, int c) { return NULL; }
 
 #endif	/* NUMA */
-- 
1.6.6

