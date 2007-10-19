Return-Path: <linux-kernel-owner+w=401wt.eu-S935276AbXJSRzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276AbXJSRzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763890AbXJSRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:55:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53575 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761967AbXJSRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:55:10 -0400
Date: Fri, 19 Oct 2007 10:53:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sam@ravnborg.org, zippel@linux-m68k.org
Subject: [PATCH v3] kconfig: update kconfig-language text
Message-Id: <20071019105348.08860145.randy.dunlap@oracle.com>
In-Reply-To: <20070813185431.GD18945@stusta.de>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com>
	<20070813185431.GD18945@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

Add kconfig-language docs for mainmenu, def_bool, and def_tristate.
Remove "requires" as a synonym of "depends on" since it was removed
from  the parser in commit 247537b9a270b52cc0375adcb0fb2605a160cba5.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kbuild/kconfig-language.txt |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- linux-2.6.23-git13.orig/Documentation/kbuild/kconfig-language.txt
+++ linux-2.6.23-git13/Documentation/kbuild/kconfig-language.txt
@@ -77,7 +77,12 @@ applicable everywhere (see syntax).
   Optionally, dependencies only for this default value can be added with
   "if".
 
-- dependencies: "depends on"/"requires" <expr>
+- type definition + default value:
+	"def_bool"/"def_tristate" <expr> ["if" <expr>]
+  This is a shorthand notation for a type definition plus a value.
+  Optionally dependencies for this default value can be added with "if".
+
+- dependencies: "depends on" <expr>
   This defines a dependency for this menu entry. If multiple
   dependencies are defined, they are connected with '&&'. Dependencies
   are applied to all other options within this menu entry (which also
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

