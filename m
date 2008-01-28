Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbYA1XNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbYA1XNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763859AbYA1XKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:10:06 -0500
Received: from zakalwe.fi ([80.83.5.154]:34201 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764062AbYA1XKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:10:01 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Improve Documentation/stable_api_nonsense.txt
Message-Id: <20080128230959.AA1A32BC98@zakalwe.fi>
Date: Tue, 29 Jan 2008 01:09:59 +0200 (EET)
From: shdl@zakalwe.fi (Heikki Orsila)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make a remark about avoiding unnecessary changes in interfaces
* Improve wording

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
---
 Documentation/stable_api_nonsense.txt |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/stable_api_nonsense.txt b/Documentation/stable_api_nonsense.txt
index 847b342..e644099 100644
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
@@ -68,11 +68,11 @@ consider the following facts about the Linux kernel:
     There is no way that binary drivers from one architecture will run
     on another architecture properly.
 
-Now a number of these issues can be addressed by simply compiling your
-module for the exact specific kernel configuration, using the same exact
+Now, a number of these issues can be addressed by simply compiling your
+module for the same kernel configuration, using the same
 C compiler that the kernel was built with.  This is sufficient if you
 want to provide a module for a specific release version of a specific
-Linux distribution.  But multiply that single build by the number of
+Linux distribution. However, multiply that single build by the number of
 different Linux distributions and the number of different supported
 releases of the Linux distribution and you quickly have a nightmare of
 different build options on different releases.  Also realize that each
@@ -93,7 +93,7 @@ keep a Linux kernel driver that is not in the main kernel tree up to
 date over time.
 
 Linux kernel development is continuous and at a rapid pace, never
-stopping to slow down.  As such, the kernel developers find bugs in
+slowing down.  As such, the kernel developers find bugs in
 current interfaces, or figure out a better way to do things.  If they do
 that, they then fix the current interfaces to work better.  When they do
 so, function names may change, structures may grow or shrink, and
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
 
+Some complain that kernel interfaces change too often for out-of-the-tree
+modules, but this claim is false. Changing an interface can be delicate work,
+and it can take significant amount of developer effort. Therefore, interfaces
+are not changed without a good reason.
 
 What to do
 ----------
-- 
1.5.3.4.GIT

