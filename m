Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXLCQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXLCQr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXLCQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:47:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbXLCQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:47:47 -0500
Message-ID: <47543339.7010104@anagramm.de>
Date: Mon, 03 Dec 2007 17:47:53 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/BUG-HUNTING whitespace cleanup, take 2
References: <475405A9.4030608@anagramm.de> <20071203083101.93141c4b.randy.dunlap@oracle.com>
In-Reply-To: <20071203083101.93141c4b.randy.dunlap@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------030908050106090003010006"
X-Provags-ID: V01U2FsdGVkX18oUq+BbUKCZ0e1eE8JhD8CY3m4T+a2UblhG1D
 XPv21dAHorhwf2FsbN6tZOn5N+9mIuXGj7NBByGZL+yraJ35BG
 G/cdA8ghED1sRwF52gBaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030908050106090003010006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Randy Dunlap schrieb:
 > On Mon, 03 Dec 2007 14:33:29 +0100 Clemens Koller wrote:
 >
 >> Just a little whitespace cleanup patch for Documentation/BUG-HUNTING.
 >>
 >> Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>
 >
 >
 > Mostly looks OK, except for the last chunk:  why delete that line?
 > missing a + line?
 >
 >
 > @@ -130,7 +130,6 @@ You will then do:
 >              that makes the difference.
 >
 >  Finally, you take all the info that you have, kernel revisions, bug
 > -description, the extent to which you have narrowed it down, and pass
 >  that off to whomever you believe is the maintainer of that section.
 >  A post to linux.dev.kernel isn't such a bad idea if you've done some
 >  work to narrow it down.

Hmm... that was not intended, updated patch attached.

Thank you,
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


--------------030908050106090003010006
Content-Type: text/plain;
 name="BUG-HUNTING-whitespace-cleanup-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="BUG-HUNTING-whitespace-cleanup-2.patch"

Just a little whitespace cleanup patch for Documentation/BUG-HUNTING

Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>

diff --git a/Documentation/BUG-HUNTING b/Documentation/BUG-HUNTING
index 35f5bd2..6c81675 100644
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
@@ -130,7 +130,7 @@ You will then do:
             that makes the difference.
 
 Finally, you take all the info that you have, kernel revisions, bug
-description, the extent to which you have narrowed it down, and pass 
+description, the extent to which you have narrowed it down, and pass
 that off to whomever you believe is the maintainer of that section.
 A post to linux.dev.kernel isn't such a bad idea if you've done some
 work to narrow it down.

--------------030908050106090003010006--
