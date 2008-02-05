Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYBEUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYBEUb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYBEUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:31:49 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:47498 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbYBEUbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:31:48 -0500
Date: Tue, 5 Feb 2008 22:31:46 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86 mmiotrace: comment about user space ABI
Message-ID: <20080205223146.06ce0c93@daedalus.pq.iki.fi>
In-Reply-To: <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 include/linux/mmiotrace.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index cb24782..6ec288f 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -3,6 +3,10 @@
 
 #include <asm/types.h>
 
+/*
+ * If you change anything here, you must bump MMIO_VERSION.
+ * This is the relay data format for user space.
+ */
 #define MMIO_VERSION 0x04
 
 /* mm_io_header.type */
@@ -23,7 +27,7 @@ enum mm_io_opcode {          /* payload type: */
 };
 
 struct mm_io_header {
-	__u32 type;
+	__u32 type;     /* see MMIO_* macros above */
 	__u32 sec;      /* timestamp */
 	__u32 nsec;
 	__u32 pid;      /* PID of the process, or 0 for kernel core */
-- 
1.5.3.7

