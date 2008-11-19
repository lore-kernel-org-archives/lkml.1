Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYKSTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYKSTRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYKSTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:17:39 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:37143 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYKSTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:17:38 -0500
Date: Wed, 19 Nov 2008 11:15:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jaharkes@cs.cmu.edu,
       dhowells@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] coda: fix creds reference
Message-Id: <20081119111556.b20c9895.randy.dunlap@oracle.com>
In-Reply-To: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.492465F2.0149:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I guess that Stephen carried this patch for a few weeks, but now
he has stopped carrying linux-next build patches.
Still broken.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From: Randy Dunlap <randy.dunlap@oracle.com>

Needs a header file for credentials struct:

linux-next-20081023/fs/coda/file.c:177: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>
---
 fs/coda/file.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20081119.orig/fs/coda/file.c
+++ linux-next-20081119/fs/coda/file.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
+#include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
