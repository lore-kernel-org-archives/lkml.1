Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYC1Oq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYC1Oq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYC1Ogu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:36:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbYC1OfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:35:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/45] NFS: Permit local filesystem caching to be enabled for
	NFS [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:32:50 +0000
Message-ID: <20080328143250.3483.34907.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit local filesystem caching to be enabled for NFS in the kernel
configuration.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/fs/Kconfig b/fs/Kconfig
index 6ca14c1..944c34b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1644,6 +1644,14 @@ config NFS_V4
 
 	  If unsure, say N.
 
+config NFS_FSCACHE
+	bool "Provide NFS client caching support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
+	help
+	  Say Y here if you want NFS data to be cached locally on disc through
+	  the general filesystem cache manager
+
 config NFS_DIRECTIO
 	bool "Allow direct I/O on NFS files"
 	depends on NFS_FS

