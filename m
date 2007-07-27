Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbXG0T75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbXG0T75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762969AbXG0T7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:59:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14819 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762185AbXG0T7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:59:48 -0400
Date: Fri, 27 Jul 2007 12:31:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] pnp: fix kernel-doc warnings
Message-Id: <20070727123116.e69597cb.randy.dunlap@oracle.com>
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

Fix PNP docbook warnings:

Warning(linux-2623-rc1g4//drivers/pnp/core.c): no structured comments found
Warning(linux-2623-rc1g4//drivers/pnp/driver.c): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2623-rc1g4.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2623-rc1g4/Documentation/DocBook/kernel-api.tmpl
@@ -398,12 +398,12 @@ X!Edrivers/acpi/pci_bind.c
 -->
      </sect1>
      <sect1><title>Device drivers PnP support</title>
-!Edrivers/pnp/core.c
+!Idrivers/pnp/core.c
 <!-- No correct structured comments
 X!Edrivers/pnp/system.c
  -->
 !Edrivers/pnp/card.c
-!Edrivers/pnp/driver.c
+!Idrivers/pnp/driver.c
 !Edrivers/pnp/manager.c
 !Edrivers/pnp/support.c
      </sect1>
