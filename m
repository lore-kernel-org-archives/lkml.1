Return-Path: <linux-kernel-owner+w=401wt.eu-S935438AbZDAXVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438AbZDAXVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933563AbZDAXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:06:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933632AbZDAXFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:05:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/43] NFS: Permit local filesystem caching to be enabled for
	NFS [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:05:51 +0100
Message-ID: <20090401230551.28177.69078.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit local filesystem caching to be enabled for NFS in the kernel
configuration.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 36fe20d..e67f3ec 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -84,3 +84,11 @@ config ROOT_NFS
 	  <file:Documentation/filesystems/nfsroot.txt>.
 
 	  Most people say N here.
+
+config NFS_FSCACHE
+	bool "Provide NFS client caching support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
+	help
+	  Say Y here if you want NFS data to be cached locally on disc through
+	  the general filesystem cache manager

