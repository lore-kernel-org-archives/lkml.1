Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007Ab0A0UZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0A0UZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112Ab0A0UYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:24:39 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35046 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0A0UYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ukxcoma7Mv2t8H+jpMAV+NqnDvhN8avL4Qn8tT8xL5MOWv9nIlBe8tqGXseFDEQkLs
         TpwJgdEOhLU99jyUxn7YbZhb/o2LMdBQGfWLfq2c6WAPyO1tLkAmLMK77vOcxHRY2SOK
         Q2IfxjudiFGJuh5hrlwjKuoFaDTGIzc1+fFpE=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <C.Emde@osadl.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/5] rt-tests: Add header including copyright notice to rt_numa.h
Date: Wed, 27 Jan 2010 21:24:24 +0100
Message-Id: <1264623868-23595-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
References: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a header which includes a copyright notice to rt_numa.h for cyclictest.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 src/cyclictest/rt_numa.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/src/cyclictest/rt_numa.h b/src/cyclictest/rt_numa.h
index a0ebe7f..14837ff 100644
--- a/src/cyclictest/rt_numa.h
+++ b/src/cyclictest/rt_numa.h
@@ -1,3 +1,16 @@
+/*
+ * A numa library for cyclictest.
+ * The functions here are designed to work whether cyclictest has been
+ * compiled with numa support or not, and whether the user uses the --numa
+ * option or not.
+ * They should also work correctly with older versions of the numactl lib
+ * such as the one found on RHEL5, or with the newer version 2 and above.
+ *
+ * (C) 2010 John Kacur <jkacur@redhat.com>
+ * (C) 2010 Clark Williams <williams@redhat.com>
+ *
+ */
+
 #ifndef _RT_NUMA_H
 #define _RT_NUMA_H
 
-- 
1.6.6

