Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYDMS05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYDMS05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYDMS0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:26:49 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:50654 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYDMS0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:26:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: akpm@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Date: Sun, 13 Apr 2008 22:26:41 +0400
Message-Id: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of typos crept into the newly added document
about the seq_file interface. This patch corrects those
typos and simultaneously deletes a few superfluous blanks.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 Documentation/filesystems/seq_file.txt |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index cc6cdb9..2b6aba6 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -6,7 +6,7 @@ The seq_file interface
 
 
 There are numerous ways for a device driver (or other kernel component) to
-provide information to the user or system administrator.  One useful
+provide information to the user or system administrator. One useful
 technique is the creation of virtual files, in debugfs, /proc or elsewhere.
 Virtual files can provide human-readable output that is easy to get at
 without any special utility programs; they can also make life easier for
@@ -16,7 +16,7 @@ grown over the years.
 Creating those files correctly has always been a bit of a challenge,
 however. It is not that hard to make a virtual file which returns a
 string. But life gets trickier if the output is long - anything greater
-than an application is likely to read in a single operation.  Handling
+than an application is likely to read in a single operation. Handling
 multiple reads (and seeks) requires careful attention to the reader's
 position within the virtual file - that position is, likely as not, in the
 middle of a line of output. The kernel has traditionally had a number of
@@ -50,7 +50,7 @@ following:
 
 Then concatenate the output files out1 and out2 and get the right
 result. Yes, it is a thoroughly useless module, but the point is to show
-how the mechanism works without getting lost in other details.  (Those
+how the mechanism works without getting lost in other details. (Those
 wanting to see the full source for this module can find it at
 http://lwn.net/Articles/22359/).
 
@@ -92,14 +92,14 @@ implementations; in most cases the start() function should check for a
 "past end of file" condition and return NULL if need be.
 
 For more complicated applications, the private field of the seq_file
-structure can be used. There is also a special value whch can be returned
+structure can be used. There is also a special value which can be returned
 by the start() function called SEQ_START_TOKEN; it can be used if you wish
 to instruct your show() function (described below) to print a header at the
 top of the output. SEQ_START_TOKEN should only be used if the offset is
 zero, however.
 
 The next function to implement is called, amazingly, next(); its job is to
-move the iterator forward to the next position in the sequence.  The
+move the iterator forward to the next position in the sequence. The
 example module can simply increment the position by one; more useful
 modules will do what is needed to step through some data structure. The
 next() function returns a new iterator, or NULL if the sequence is
@@ -146,7 +146,7 @@ the four functions we have just defined:
 This structure will be needed to tie our iterator to the /proc file in
 a little bit.
 
-It's worth noting that the interator value returned by start() and
+It's worth noting that the iterator value returned by start() and
 manipulated by the other functions is considered to be completely opaque by
 the seq_file code. It can thus be anything that is useful in stepping
 through the data to be output. Counters can be useful, but it could also be
@@ -261,13 +261,13 @@ routines useful:
 					loff_t *ppos);
 
 These helpers will interpret pos as a position within the list and iterate
-accordingly.  Your start() and next() functions need only invoke the
-seq_list_* helpers with a pointer to the appropriate list_head structure.  
+accordingly. Your start() and next() functions need only invoke the
+seq_list_* helpers with a pointer to the appropriate list_head structure.
 
 
 The extra-simple version
 
-For extremely simple virtual files, there is an even easier interface.  A
+For extremely simple virtual files, there is an even easier interface. A
 module can define only the show() function, which should create all the
 output that the virtual file will contain. The file's open() method then
 calls:
-- 
1.5.3

