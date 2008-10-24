Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYJXBTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYJXBTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbYJXBSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:18:45 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:23820 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbYJXBSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:18:44 -0400
Date: Thu, 23 Oct 2008 18:17:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] coda: credentials error
Message-Id: <20081023181745.7991a823.randy.dunlap@oracle.com>
In-Reply-To: <20081023213637.eff9b414.sfr@canb.auug.org.au>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49012245.015E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Needs a header file for credentials struct:

linux-next-20081023/fs/coda/file.c:177: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/coda/file.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20081023.orig/fs/coda/file.c
+++ linux-next-20081023/fs/coda/file.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
+#include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
