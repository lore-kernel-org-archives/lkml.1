Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZDMCGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZDMCGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZDMCGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:06:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62501 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZDMCGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:06:08 -0400
Message-Id: <200904130204.n3D24JNk095583@www262.sakura.ne.jp>
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: pavel@ucw.cz, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Apr 2009 11:04:19 +0900
References: <20090408133126.180521064@I-love.SAKURA.ne.jp> <20090408133524.395437925@I-love.SAKURA.ne.jp> <20090410171001.GA26156@elf.ucw.cz>
In-Reply-To: <20090410171001.GA26156@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 12042009 #1843665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Pavel Machek wrote:
> Could we get an user<->kernel interface documentation?

It is at http://tomoyo.sourceforge.jp/en/2.2.x/policy-reference.html .

> > +--- How to enable TOMOYO? ---
> > +
> > +Build the kernel with CONFIG_SECURITY_TOMOYO=y and pass "security=tomoyo" to
> > +kernel's command line.
> 
> "on kernel's" ?
> 
> > +--- Where are documentations? ---
> 
> "Where is documentation?"

Updated. Thanks.

James, please apply the below updated one and the one at http://lkml.org/lkml/2009/4/10/170 (Subject: [TOMOYO 2/2] tomoyo: version bump to 2.2.0.).
----------
Subject: tomoyo: add Documentation/tomoyo.txt

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 Documentation/tomoyo.txt |   55 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- /dev/null
+++ linux-2.6.30-rc1/Documentation/tomoyo.txt
@@ -0,0 +1,55 @@
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
+Build the kernel with CONFIG_SECURITY_TOMOYO=y and pass "security=tomoyo" on
+kernel's command line.
+
+Please see http://tomoyo.sourceforge.jp/en/2.2.x/ for details.
+
+--- Where is documentation? ---
+
+User <-> Kernel interface documentation is available at
+http://tomoyo.sourceforge.jp/en/2.2.x/policy-reference.html .
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
