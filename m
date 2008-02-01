Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYBAGJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYBAGJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYBAGJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:09:12 -0500
Received: from xenotime.net ([66.160.160.81]:33153 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750925AbYBAGJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:09:11 -0500
Date: Thu, 31 Jan 2008 22:09:08 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       mporter@kernel.crashing.org
Subject: [PATCH] docbook: rapidio: fix fatal filename error
Message-ID: <Pine.LNX.4.64.0801312207010.14603@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook fatal error (files were renamed):
docproc: linux-2.6.24-git9/arch/ppc/kernel/rio.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  Documentation/DocBook/rapidio.tmpl |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-git9.orig/Documentation/DocBook/rapidio.tmpl
+++ linux-2.6.24-git9/Documentation/DocBook/rapidio.tmpl
@@ -133,9 +133,9 @@
  !Idrivers/rapidio/rio-sysfs.c
       </sect1>
       <sect1><title>PPC32 support</title>
-!Iarch/ppc/kernel/rio.c
-!Earch/ppc/syslib/ppc85xx_rio.c
-!Iarch/ppc/syslib/ppc85xx_rio.c
+!Iarch/powerpc/kernel/rio.c
+!Earch/powerpc/sysdev/fsl_rio.c
+!Iarch/powerpc/sysdev/fsl_rio.c
       </sect1>
    </chapter>

