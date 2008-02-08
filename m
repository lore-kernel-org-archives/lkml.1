Return-Path: <linux-kernel-owner+w=401wt.eu-S935015AbYBHSGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbYBHSGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934649AbYBHSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:00:25 -0500
Received: from flpi102.sbcis.sbc.com ([207.115.20.71]:20269 "EHLO
	flpi102.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbYBHSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:00:19 -0500
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 09/11] NFSD: Move "select NFSD_V2_ACL if NFSD_V3_ACL"
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Date: Fri, 08 Feb 2008 12:52:29 -0500
Message-ID: <20080208175229.16261.10929.stgit@manray.1015granger.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up: since NFSD_V2_ACL is a boolean, it can be selected safely
under the NFSD_V3_ACL entry (also a boolean).

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---

 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 32c84d9..21362e9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1657,7 +1657,6 @@ config NFSD
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
-	select NFSD_V2_ACL if NFSD_V3_ACL
 	select NFS_ACL_SUPPORT if NFSD_V2_ACL
 	select CRYPTO_MD5 if NFSD_V4
 	select CRYPTO if NFSD_V4
@@ -1699,6 +1698,7 @@ config NFSD_V3
 config NFSD_V3_ACL
 	bool "NFS server support for the NFSv3 ACL protocol extension"
 	depends on NFSD_V3
+	select NFSD_V2_ACL
 	help
 	  Solaris NFS servers support an auxiliary NFSv3 ACL protocol that
 	  never became an official part of the NFS version 3 protocol.

