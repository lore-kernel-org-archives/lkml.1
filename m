Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYJWLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYJWLI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYJWLG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:57 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50743 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYJWLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:55 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 5/9] checkpatch: __weak is an official attribute
Date: Thu, 23 Oct 2008 12:06:35 +0100
Message-Id: <1224759999-21389-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __weak as an official attribute.  This tends to be used in a location
where the automated attribute detector misses it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5551eb1..90f78ef 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -116,7 +116,8 @@ our $Attribute	= qr{
 			__(?:mem|cpu|dev|)(?:initdata|init)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
-			____cacheline_internodealigned_in_smp
+			____cacheline_internodealigned_in_smp|
+			__weak
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
-- 
1.6.0.2.711.gf1ba4

