Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXLCNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXLCNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXLCNdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:33:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:58422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXLCNdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:33:23 -0500
Message-ID: <475405A9.4030608@anagramm.de>
Date: Mon, 03 Dec 2007 14:33:29 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/BUG-HUNTING whitespace cleanup
Content-Type: multipart/mixed;
 boundary="------------040002050303080806060800"
X-Provags-ID: V01U2FsdGVkX19XO4VZOWVJuUq9Ny5rr2Z35NYA52Fu5WNm71J
 /6v2nIM3FoGPed5cJ4j0iyplTa73X4Va7gHhLrTjlHKK5xi17k
 VhiNtL3aaqkNgt/q09KXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040002050303080806060800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Just a little whitespace cleanup patch for Documentation/BUG-HUNTING.

Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>

-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

--------------040002050303080806060800
Content-Type: text/plain;
 name="BUG-HUNTING-whitespace-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="BUG-HUNTING-whitespace-cleanup.patch"

diff --git a/Documentation/BUG-HUNTING b/Documentation/BUG-HUNTING
index 35f5bd2..a41cb24 100644
--- a/Documentation/BUG-HUNTING
+++ b/Documentation/BUG-HUNTING
@@ -53,7 +53,7 @@ Finding it the old way
 
 [Sat Mar  2 10:32:33 PST 1996 KERNEL_BUG-HOWTO lm@sgi.com (Larry McVoy)]
 
-This is how to track down a bug if you know nothing about kernel hacking.  
+This is how to track down a bug if you know nothing about kernel hacking.
 It's a brute force approach but it works pretty well.
 
 You need:
@@ -66,12 +66,12 @@ You will then do:
 
         . Rebuild a revision that you believe works, install, and verify that.
         . Do a binary search over the kernels to figure out which one
-          introduced the bug.  I.e., suppose 1.3.28 didn't have the bug, but 
+          introduced the bug.  I.e., suppose 1.3.28 didn't have the bug, but
           you know that 1.3.69 does.  Pick a kernel in the middle and build
           that, like 1.3.50.  Build & test; if it works, pick the mid point
           between .50 and .69, else the mid point between .28 and .50.
         . You'll narrow it down to the kernel that introduced the bug.  You
-          can probably do better than this but it gets tricky.  
+          can probably do better than this but it gets tricky.
 
         . Narrow it down to a subdirectory
 
@@ -81,27 +81,27 @@ You will then do:
             directories:
 
                 Copy the non-working directory next to the working directory
-                as "dir.63".  
+                as "dir.63".
                 One directory at time, try moving the working directory to
-                "dir.62" and mv dir.63 dir"time, try 
+                "dir.62" and mv dir.63 dir"time, try
 
                         mv dir dir.62
                         mv dir.63 dir
                         find dir -name '*.[oa]' -print | xargs rm -f
 
                 And then rebuild and retest.  Assuming that all related
-                changes were contained in the sub directory, this should 
-                isolate the change to a directory.  
+                changes were contained in the sub directory, this should
+                isolate the change to a directory.
 
                 Problems: changes in header files may have occurred; I've
-                found in my case that they were self explanatory - you may 
+                found in my case that they were self explanatory - you may
                 or may not want to give up when that happens.
 
         . Narrow it down to a file
 
           - You can apply the same technique to each file in the directory,
-            hoping that the changes in that file are self contained.  
-            
+            hoping that the changes in that file are self contained.
+
         . Narrow it down to a routine
 
           - You can take the old file and the new file and manually create
@@ -130,7 +130,6 @@ You will then do:
             that makes the difference.
 
 Finally, you take all the info that you have, kernel revisions, bug
-description, the extent to which you have narrowed it down, and pass 
 that off to whomever you believe is the maintainer of that section.
 A post to linux.dev.kernel isn't such a bad idea if you've done some
 work to narrow it down.

--------------040002050303080806060800--
