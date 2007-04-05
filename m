Return-Path: <linux-kernel-owner+w=401wt.eu-S1161155AbXDEE5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155AbXDEE5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXDEE5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:57:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29933 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161155AbXDEE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:57:23 -0400
Date: Wed, 4 Apr 2007 21:58:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: zippel@linux-m68k.org, sam@ravnborg.org
Subject: [PATCH] kbuild: be more explicit on missing .config file
Message-Id: <20070404215841.2647cf6d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Somewhat in reponse to kernel bugzilla #8197, be more explicit about
why 'make all' fails when there is no .config file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kconfig/conf.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2621-rc5g6.orig/scripts/kconfig/conf.c
+++ linux-2621-rc5g6/scripts/kconfig/conf.c
@@ -558,6 +558,7 @@ int main(int ac, char **av)
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
+				"*** (missing kernel .config file)\n"
 				"***\n"
 				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
 				"*** \"make menuconfig\" or \"make xconfig\").\n"
