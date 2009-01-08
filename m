Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZAHSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZAHSNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZAHSN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:13:29 -0500
Received: from mx2.netapp.com ([216.240.18.37]:57285 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbZAHSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:13:29 -0500
X-IronPort-AV: E=Sophos;i="4.37,235,1231142400"; 
   d="scan'208";a="109925471"
Date: Thu, 8 Jan 2009 13:13:26 -0500 (EST)
From: James Lentini <jlentini@netapp.com>
X-X-Sender: jlentini@jlentini-linux.nane.netapp.com
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: [PATCH] NFS/RDMA documentation update
Message-ID: <alpine.LFD.2.00.0901081309060.3209@jlentini-linux.nane.netapp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bruce,

Please consider this patch for 2.6.29:

Update the NFS/RDMA documentation to use the new port number assigned 
by IANA.

Signed-off-by: James Lentini <jlentini@netapp.com>
---

 nfs-rdma.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/nfs-rdma.txt	2008-12-24 18:26:37.000000000 -0500
+++ b/Documentation/filesystems/nfs-rdma.txt	2009-01-08 09:52:32.193769000 -0500
@@ -251,7 +251,7 @@
 
     Instruct the server to listen on the RDMA transport:
 
-    $ echo rdma 2050 > /proc/fs/nfsd/portlist
+    $ echo rdma 20049 > /proc/fs/nfsd/portlist
 
   - On the client system
 
@@ -263,7 +263,7 @@
     Regardless of how the client was built (module or built-in), use this
     command to mount the NFS/RDMA server:
 
-    $ mount -o rdma,port=2050 <IPoIB-server-name-or-address>:/<export> /mnt
+    $ mount -o rdma,port=20049 <IPoIB-server-name-or-address>:/<export> /mnt
 
     To verify that the mount is using RDMA, run "cat /proc/mounts" and check
     the "proto" field for the given mount.
