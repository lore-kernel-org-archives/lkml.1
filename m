Return-Path: <linux-kernel-owner+w=401wt.eu-S940559AbXGSRUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940559AbXGSRUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940505AbXGSRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:20:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20279 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939222AbXGSRUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:20:22 -0400
Date: Thu, 19 Jul 2007 10:22:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] docbook bad file references
Message-Id: <20070719102237.2f0a41cf.randy.dunlap@oracle.com>
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

Fix docbook warnings:

Warning(linux-2.6.22-git12//drivers/base/power/main.c): no structured comments found
Warning(linux-2.6.22-git12//include/linux/splice.h): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.22-git12.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.22-git12/Documentation/DocBook/kernel-api.tmpl
@@ -381,7 +381,6 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers Power Management</title>
-!Edrivers/base/power/main.c
 !Edrivers/base/power/resume.c
 !Edrivers/base/power/suspend.c
      </sect1>
@@ -710,7 +709,6 @@ X!Idrivers/video/console/fonts.c
 	kernel, without continually transferring it between the kernel
 	and user space.
   </para>
-!Iinclude/linux/splice.h
 !Ffs/splice.c
   </chapter>
 
