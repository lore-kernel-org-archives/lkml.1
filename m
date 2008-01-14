Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYANRUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYANRUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYANRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:20:05 -0500
Received: from baron.coraid.com ([65.14.39.133]:6805 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750894AbYANRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:20:04 -0500
Date: Mon, 14 Jan 2008 12:18:30 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, ecashin@coraid.com
Subject: Re: [PATCH] Documentation: Add 00-INDEX file for AoE
Message-ID: <20080114171830.GL3304@coraid.com>
References: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 02:44:48AM +0100, Jesper Juhl wrote:
> Documentation/aoe/ is missing a 00-INDEX file. Add one.

Thanks.  I think that it would help to clarify that using udev is the
norm, and that the mkdev and mkshelf scripts are just examples to show
how you could do it manually.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>

diff --git a/Documentation/aoe/00-INDEX b/Documentation/aoe/00-INDEX
index 8188b22..d087df6 100644
--- a/Documentation/aoe/00-INDEX
+++ b/Documentation/aoe/00-INDEX
@@ -5,9 +5,10 @@ aoe.txt
 autoload.sh
 	- script for making the AoE driver autoload via /etc/modprobe.conf.
 mkdevs.sh
-	- script for creating required AoE device nodes.
+	- script for creating required AoE device nodes without udev.
 mkshelf.sh
-	- script for making one shelf's worth of block device nodes.
+	- script for making one shelf's worth of block device nodes
+	  without udev.
 status.sh
 	- script to collate and present sysfs information about AoE storage.
 todo.txt
diff --git a/Documentation/aoe/mkdevs.sh b/Documentation/aoe/mkdevs.sh
index 97374aa..5870a6c 100644
--- a/Documentation/aoe/mkdevs.sh
+++ b/Documentation/aoe/mkdevs.sh
@@ -1,4 +1,7 @@
 #!/bin/sh
+# This example script shows how device nodes for interacting with the
+# aoe driver could be created in the absence of udev.  Using udev is
+# preferable to creating them manually.
 
 n_shelves=${n_shelves:-10}
 n_partitions=${n_partitions:-16}
diff --git a/Documentation/aoe/mkshelf.sh b/Documentation/aoe/mkshelf.sh
index 3261581..7f412f0 100644
--- a/Documentation/aoe/mkshelf.sh
+++ b/Documentation/aoe/mkshelf.sh
@@ -1,4 +1,7 @@
 #! /bin/sh
+# This example script shows how device nodes for interacting with the
+# aoe driver could be created in the absence of udev.  Using udev is
+# preferable to creating them manually.
 
 if test "$#" != "2"; then
 	echo "Usage: sh `basename $0` {dir} {shelfaddress}" 1>&2


-- 
  Ed L Cashin <ecashin@coraid.com>
