Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZHUQ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZHUQ4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZHUQ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:56:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31699 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbZHUQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:56:47 -0400
Date: Fri, 21 Aug 2009 09:57:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH -mmotm] nfs/cache_lib: fix sunrpc struct build error
Message-Id: <20090821095756.390c102e.randy.dunlap@oracle.com>
In-Reply-To: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A8ED1A8.0257:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file for struct delayed_work:

In file included from fs/nfs/cache_lib.c:14:
include/linux/sunrpc/rpc_pipe_fs.h:35: error: field 'queue_timeout' has incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/sunrpc/rpc_pipe_fs.h |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm-2009-0820-1918.orig/include/linux/sunrpc/rpc_pipe_fs.h
+++ mmotm-2009-0820-1918/include/linux/sunrpc/rpc_pipe_fs.h
@@ -3,6 +3,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/workqueue.h>
+
 struct rpc_pipe_msg {
 	struct list_head list;
 	void *data;



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
