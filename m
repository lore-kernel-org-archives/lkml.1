Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYBBOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYBBOpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763351AbYBBOpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:45:04 -0500
Received: from zakalwe.fi ([80.83.5.154]:47754 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763019AbYBBOpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:45:01 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Cc: greg@kroah.com, mpm@selenic.com, ak@suse.de, m-ikeda@ds.jp.nec.com,
       zhongyu@18mail.cn, minchan.kim@gmail.com
Message-Id: <20080202144457.653482BC98@zakalwe.fi>
Date: Sat,  2 Feb 2008 16:44:57 +0200 (EET)
From: shdl@zakalwe.fi (Heikki Orsila)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 2 of the patch. Address Gregs, Matts and Andis comments.
Retain the word "exact" due to request of Greg. Use "the exact
same" as per "Matt Mackall".

* Change wording
* Make a remark about necessary changes in interfaces

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
---
 Documentation/stable_api_nonsense.txt |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/stable_api_nonsense.txt b/Documentation/stable_api_nonsense.txt
index 847b342..a7c29ad 100644
--- a/Documentation/stable_api_nonsense.txt
+++ b/Documentation/stable_api_nonsense.txt
@@ -19,7 +19,7 @@ Executive Summary
 You think you want a stable kernel interface, but you really do not, and
 you don't even know it.  What you want is a stable running driver, and
 you get that only if your driver is in the main kernel tree.  You also
-get lots of other good benefits if your driver is in the main kernel
+get lots of other benefits if your driver is in the main kernel
 tree, all of which has made Linux into such a strong, stable, and mature
 operating system which is the reason you are using it in the first
 place.
@@ -69,7 +69,7 @@ consider the following facts about the Linux kernel:
     on another architecture properly.
 
 Now a number of these issues can be addressed by simply compiling your
-module for the exact specific kernel configuration, using the same exact
+module for the exact same kernel configuration, using the exact same
 C compiler that the kernel was built with.  This is sufficient if you
 want to provide a module for a specific release version of a specific
 Linux distribution.  But multiply that single build by the number of
@@ -116,7 +116,7 @@ issues:
 
 This is in stark contrast to a number of closed source operating systems
 which have had to maintain their older USB interfaces over time.  This
-provides the ability for new developers to accidentally use the old
+has the risk for new developers to accidentally use the old
 interfaces and do things in improper ways, causing the stability of the
 operating system to suffer.
 
@@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
 well as they can be (unused interfaces are pretty much impossible to
 test for validity.)
 
+However, changing an interface can be delicate work and it can take
+significant amount of developer effort. Therefore, an interface is
+not changed unless the change is regarded as very important by the
+developers.
 
 What to do
 ----------
-- 
1.5.3.4.GIT

