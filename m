Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030460Ab0B0Q4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:56:19 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030436Ab0B0Q4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=owD3xaXWWS9d1xcGfU4znADXBX7d6pktMgs4eDFYc1v/Z82oOSbMWRnI0qGrPbwrpN
         IQqrXVuiu8KHiGFxfZouhT0CFJLtgT0PHzKoztYd1KQTmR2OQQe0uR9CnA78W+CcwPyN
         vayxAaSZAWbMO9+/QnRfu6f2HewA3cDV17xcY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Subject: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:23 +0100
Message-Id: <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mips/lib/libgcc.h:21: ERROR: open brace '{' following union go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/mips/lib/libgcc.h |    3 +--
 arch/sh/lib/libgcc.h   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lib/libgcc.h b/arch/mips/lib/libgcc.h
index 3f19d1c..05909d5 100644
--- a/arch/mips/lib/libgcc.h
+++ b/arch/mips/lib/libgcc.h
@@ -17,8 +17,7 @@ struct DWstruct {
 #error I feel sick.
 #endif
 
-typedef union
-{
+typedef union {
 	struct DWstruct s;
 	long long ll;
 } DWunion;
diff --git a/arch/sh/lib/libgcc.h b/arch/sh/lib/libgcc.h
index 3f19d1c..05909d5 100644
--- a/arch/sh/lib/libgcc.h
+++ b/arch/sh/lib/libgcc.h
@@ -17,8 +17,7 @@ struct DWstruct {
 #error I feel sick.
 #endif
 
-typedef union
-{
+typedef union {
 	struct DWstruct s;
 	long long ll;
 } DWunion;
-- 
1.7.0.90.g251a4

