Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZLFHfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZLFHfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZLFHfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZLFHey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tvIXTfKx1hxgccRsAncYmVNOwXWYItv6qWNkwrguzGtVdkEP+lTMYEl+7nzcRRSPg1
         e1ewxvANYzPbWLXb/COwK8SQtKSEH66uOAtnmypGi5HpEoorKloeXKVOfHHj4M9J9Ag/
         Bh31A0fs0qc/s81oVyRLXMdVBiDv4uE11C7KA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/9] hw-breakpoints: Add two reserved fields for future extensions
Date: Sun,  6 Dec 2009 08:34:50 +0100
Message-Id: <1260084898-11686-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two reserved fields for future extensions in the hardware
breakpoints interface. Further needs may arise.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 43adbd7..a61e4de 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -220,6 +220,8 @@ struct perf_event_attr {
 			__u64		bp_addr;
 			__u32		bp_type;
 			__u32		bp_len;
+			__u64		__bp_reserved_1;
+			__u64		__bp_reserved_2;
 		};
 	};
 
-- 
1.6.2.3

