Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbZDBPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbZDBPLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZDBPKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:10:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:42810 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZDBPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QrdttmG/ifCdZIOoHo4NR4xpnCxkaUCw/WW6vMz8BBGY1WOaSTallAlV/2qDIFXCgs
         iD2lmQTBC/4H6n1Xrelxw/BGNqIBX6voseshniFrHBVI8zl2OA0UzGgui3QeGEPRUl/h
         hVR68130Jx75ZNOKWffoE3yaJipP7j63CzdN8=
From: tom.leiming@gmail.com
To: srostedt@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ftrace: fix scripts/recordmcount.pl
Date: Thu,  2 Apr 2009 23:10:46 +0800
Message-Id: <1238685046-6477-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

$#ARGV should be nine ,and fix the usage print info.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 scripts/recordmcount.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index fe83141..a56c107 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -100,8 +100,8 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 6) {
-	print "usage: $P arch objdump objcopy cc ld nm rm mv inputfile\n";
+if ($#ARGV < 9) {
+	print "usage: $P arch bits objdump objcopy cc ld nm rm mv inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
-- 
1.6.0.GIT

