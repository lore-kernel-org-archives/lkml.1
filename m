Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXAXTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXAXTTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXAXTTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:19:54 -0500
Received: from raven.upol.cz ([158.194.120.4]:63217 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXAXTTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:19:53 -0500
Date: Wed, 24 Jan 2007 19:28:02 +0000
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] spell 4 kbuild: improving option checking
Message-ID: <20070124192801.GA8740@flower.upol.cz>
References: <20061029120858.GB3491@quickstop.soohrt.org> <slrnekcu6m.2vm.olecom@flower.upol.cz> <20061031001235.GE2933@quickstop.soohrt.org> <200610310119.10567.ak@suse.de> <20061031011416.GG2933@quickstop.soohrt.org> <20061031135136.GB16063@flower.upol.cz> <20070124085430.GA8160@flower.upol.cz> <20070124080610.0969a15f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124080610.0969a15f.randy.dunlap@oracle.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>

--- linux~2.6.20-rc5/scripts/Kbuild.include~	2007-01-24 09:19:01.386426000 +0100
+++ linux~2.6.20-rc5/scripts/Kbuild.include	2007-01-24 20:07:11.152820000 +0100
@@ -2,5 +2,5 @@
 # kbuild: Generic definitions
 
-# Convinient constants
+# Convenient constants
 comma   := ,
 squote  := '
@@ -171,5 +171,5 @@
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 
-# Execute command if command has changed or prerequisitei(s) are updated
+# Execute command if command has changed or prerequisite(s) are updated
 #
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
@@ -188,5 +188,5 @@
 
 # Usage: $(call if_changed_rule,foo)
-# will check if $(cmd_foo) changed, or any of the prequisites changed,
+# will check if $(cmd_foo) changed, or any of the prerequisites changed,
 # and if so will execute $(rule_foo)
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
@@ -233,2 +233,4 @@
 echo-why = $(call escsq, $(strip $(why)))
 endif
+
+ LocalWords:  prequisites
