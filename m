Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYDMXG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYDMXG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYDMXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:06:20 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:54153 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYDMXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:06:20 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: akpm@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: [PATCH 1/1 v2] Fix typos in Documentation/filesystems/seq_file.txt
Date: Mon, 14 Apr 2008 03:06:21 +0400
Message-Id: <1208127981-27110-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of typos crept into the newly added document
about the seq_file interface. This patch corrects those
typos and simultaneously deletes unnecessary trailing
spaces.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 Documentation/filesystems/seq_file.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index cc6cdb9..7fb8e6d 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -92,7 +92,7 @@ implementations; in most cases the start() function should check for a
 "past end of file" condition and return NULL if need be.
 
 For more complicated applications, the private field of the seq_file
-structure can be used. There is also a special value whch can be returned
+structure can be used. There is also a special value which can be returned
 by the start() function called SEQ_START_TOKEN; it can be used if you wish
 to instruct your show() function (described below) to print a header at the
 top of the output. SEQ_START_TOKEN should only be used if the offset is
@@ -146,7 +146,7 @@ the four functions we have just defined:
 This structure will be needed to tie our iterator to the /proc file in
 a little bit.
 
-It's worth noting that the interator value returned by start() and
+It's worth noting that the iterator value returned by start() and
 manipulated by the other functions is considered to be completely opaque by
 the seq_file code. It can thus be anything that is useful in stepping
 through the data to be output. Counters can be useful, but it could also be
@@ -262,7 +262,7 @@ routines useful:
 
 These helpers will interpret pos as a position within the list and iterate
 accordingly.  Your start() and next() functions need only invoke the
-seq_list_* helpers with a pointer to the appropriate list_head structure.  
+seq_list_* helpers with a pointer to the appropriate list_head structure.
 
 
 The extra-simple version
-- 
1.5.3

