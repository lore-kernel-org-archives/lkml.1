Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbXCWNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbXCWNfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 09:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934055AbXCWNfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 09:35:39 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:21141 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046AbXCWNfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 09:35:38 -0400
Message-ID: <4603D7A6.7060106@fr.ibm.com>
Date: Fri, 23 Mar 2007 14:35:34 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] remove dup_namespaces() declaration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ! 

Here's a minor fix for merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

dup_namespaces() does not exist any more, so we should remove the 
declaration from nsproxy.h.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 include/linux/nsproxy.h |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6.21-rc4-mm1/include/linux/nsproxy.h
===================================================================
--- 2.6.21-rc4-mm1.orig/include/linux/nsproxy.h
+++ 2.6.21-rc4-mm1/include/linux/nsproxy.h
@@ -31,7 +31,6 @@ struct nsproxy {
 };
 extern struct nsproxy init_nsproxy;

-struct nsproxy *dup_namespaces(struct nsproxy *orig);
 int copy_namespaces(int flags, struct task_struct *tsk);
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
