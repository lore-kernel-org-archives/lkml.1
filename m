Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbXHMStA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbXHMStA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033177AbXHMSeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:34:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10994 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S974056AbXHMSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:34:16 -0400
Date: Mon, 13 Aug 2007 11:38:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sam@ravnborg.org, zippel@linux-m68k.org,
       vincent.legoll@gmail.com
Subject: [PATCH] kconfig: update kconfig-language text
Message-Id: <20070813113809.9a715e75.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kconfig-language docs for mainmenu, def_bool[ean],
and def_tristate.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
+++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
@@ -77,6 +77,11 @@ applicable everywhere (see syntax).
   Optionally, dependencies only for this default value can be added with
   "if".
 
+- type definition + default value:
+	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
+  This is a shorthand notation for a type definition plus a value.
+  Optionally dependencies for this default value can be added with "if".
+
 - dependencies: "depends on"/"requires" <expr>
   This defines a dependency for this menu entry. If multiple
   dependencies are defined, they are connected with '&&'. Dependencies
@@ -289,3 +294,10 @@ source:
 	"source" <prompt>
 
 This reads the specified configuration file. This file is always parsed.
+
+mainmenu:
+
+	"mainmenu" <prompt>
+
+This sets the config program's title bar if the config program chooses
+to use it.
