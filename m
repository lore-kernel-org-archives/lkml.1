Return-Path: <linux-kernel-owner+w=401wt.eu-S936414AbZDJLwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414AbZDJLwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935264AbZDJLvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:51:41 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59025 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935892AbZDJLvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:51:38 -0400
Message-Id: <20090408133524.395437925@I-love.SAKURA.ne.jp>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 22:31:27 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
Content-Disposition: inline; filename=tomoyo-documentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 Documentation/tomoyo.txt |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- /dev/null
+++ linux-2.6.30-rc1/Documentation/tomoyo.txt
@@ -0,0 +1,52 @@
+--- What is TOMOYO? ---
+
+TOMOYO is a name-based MAC extension (LSM module) for the Linux kernel.
+
+LiveCD-based tutorials are available at
+http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/ubuntu8.04-live/
+http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/centos5-live/ .
+Though these tutorials use non-LSM version of TOMOYO, they are useful for you
+to know what TOMOYO is.
+
+--- How to enable TOMOYO? ---
+
+Build the kernel with CONFIG_SECURITY_TOMOYO=y and pass "security=tomoyo" to
+kernel's command line.
+
+Please see http://tomoyo.sourceforge.jp/en/2.2.x/ for details.
+
+--- Where are documentations? ---
+
+Materials we prepared for seminars and symposiums are available at
+http://sourceforge.jp/projects/tomoyo/docs/?category_id=532&language_id=1 .
+Below lists are chosen from three aspects.
+
+What is TOMOYO?
+  TOMOYO Linux Overview
+    http://sourceforge.jp/projects/tomoyo/docs/lca2009-takeda.pdf
+  TOMOYO Linux: pragmatic and manageable security for Linux
+    http://sourceforge.jp/projects/tomoyo/docs/freedomhectaipei-tomoyo.pdf
+  TOMOYO Linux: A Practical Method to Understand and Protect Your Own Linux Box
+    http://sourceforge.jp/projects/tomoyo/docs/PacSec2007-en-no-demo.pdf
+
+What can TOMOYO do?
+  Deep inside TOMOYO Linux
+    http://sourceforge.jp/projects/tomoyo/docs/lca2009-kumaneko.pdf
+  The role of "pathname based access control" in security.
+    http://sourceforge.jp/projects/tomoyo/docs/lfj2008-bof.pdf
+
+History of TOMOYO?
+  Realities of Mainlining
+    http://sourceforge.jp/projects/tomoyo/docs/lfj2008.pdf
+
+--- What is future plan? ---
+
+We believe that inode based security and name based security are complementary
+and both should be used together. But unfortunately, so far, we cannot enable
+multiple LSM modules at the same time. We feel sorry that you have to give up
+SELinux/SMACK/AppArmor etc. when you want to use TOMOYO.
+
+We hope that LSM becomes stackable in future. Meanwhile, you can use non-LSM
+version of TOMOYO, available at http://tomoyo.sourceforge.jp/en/1.6.x/ .
+LSM version of TOMOYO is a subset of non-LSM version of TOMOYO. We are planning
+to port non-LSM version's functionalities to LSM versions.

-- 
