Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbZLPWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbZLPWXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbZLPWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:23:47 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:35213 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbZLPWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:23:46 -0500
Date: Wed, 16 Dec 2009 14:23:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: [PATCH -next] nfs: fix ISO C90 warning
Message-Id: <20091216142334.6a0ba115.randy.dunlap@oracle.com>
In-Reply-To: <20091215165309.58e98eea.sfr@canb.auug.org.au>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B295DE4.0118:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc ISO C90 warning:

fs/nfs/callback.c:356: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/nfs/callback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091215.orig/fs/nfs/callback.c
+++ linux-next-20091215/fs/nfs/callback.c
@@ -352,8 +352,8 @@ static int check_gss_callback_principal(
 static int nfs_callback_authenticate(struct svc_rqst *rqstp)
 {
 	struct nfs_client *clp;
-	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 	int ret = SVC_OK;
+	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 
 	/* Don't talk to strangers */
 	clp = nfs_find_client(svc_addr(rqstp), 4);
