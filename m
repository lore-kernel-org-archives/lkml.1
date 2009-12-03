Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZLCVQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZLCVQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZLCVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:16:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35781 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZLCVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=huCp9tle+9u7I32gS7fXKFYU/qQc9wqjC6821O10MD5ybNUP/tw6SumtUp0NR1bRAV
         4FZW24XWC1qXoKqtzwTgt4rCkSB3pB3lpIl31jo1AQNhjnpXUKNG9inod69fisV/JkAU
         h4FcYnpqExNFn7dsv/TdrFPzqsxA77R+0aX9I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/2] hw-breakpoints: Add two reserved fields for future extensions
Date: Thu,  3 Dec 2009 22:16:04 +0100
Message-Id: <1259874964-7757-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com>
References: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two reserved fields for future extensions in the hardware
breakpoints interface. Further needs may arise.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/perf_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 771d04c..89832cc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -221,6 +221,8 @@ struct perf_event_attr {
 			__u64		bp_end;
 			__u32		bp_type;
 			__u32		bp_len;
+			__u64		__bp_reserved_1;
+			__u64		__bp_reserved_2;
 		};
 	};
 
-- 
1.6.2.3

