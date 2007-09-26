Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXIZDUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXIZDUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXIZDUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:20:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17968 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXIZDT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:19:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=Us4oDO+Sg8ylSdeUhsOA8L/iWjDTpx54ofiRlcESKnPnTtjMOFMRk9YaAcgw0vqge
	B/QcwNGtGS6LSu6TbCerw==
Message-ID: <46F9CFD4.3020001@google.com>
Date: Tue, 25 Sep 2007 20:19:48 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix cgroup_create_dir() comments
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment fixed, to match the actual arguments.

Signed-off-by: Balaji Rao <balajirao@gmail.com>
Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: container-2.6.23-rc8-mm1/kernel/cgroup.c
===================================================================
--- container-2.6.23-rc8-mm1.orig/kernel/cgroup.c
+++ container-2.6.23-rc8-mm1/kernel/cgroup.c
@@ -1569,7 +1569,7 @@ static int cgroup_create_file(struct den
  *	cont:	the cgroup we create the directory for.
  *		It must have a valid ->parent field
  *		And we are going to fill its ->dentry field.
- *	name:	The name to give to the cgroup directory. Will be copied.
+ *	dentry: dentry of the new container
  *	mode:	mode to set on new directory.
  */
 static int cgroup_create_dir(struct cgroup *cont, struct dentry *dentry,
