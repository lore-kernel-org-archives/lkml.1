Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZHFAv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZHFAv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZHFAvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:51:20 -0400
Received: from mail.atheros.com ([12.36.123.2]:29955 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZHFAvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:51:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>,
       <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] checkincludes.pl: provide usage helper
Date: Wed, 5 Aug 2009 17:51:11 -0700
Message-ID: <1249519872-23958-3-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scripts/checkincludes.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 32ebff6..4bff139 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -3,6 +3,15 @@
 # checkincludes: Find files included more than once in (other) files.
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
 
+sub usage {
+	print "Usage: checkincludes.pl <file list>\n";
+	exit 1;
+}
+
+if ($#ARGV < 0) {
+        usage();
+}
+
 foreach $file (@ARGV) {
 	open(FILE, $file) or die "Cannot open $file: $!.\n";
 
-- 
1.6.3.3

