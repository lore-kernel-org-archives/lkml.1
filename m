Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZAEVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZAEVnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZAEVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:43:07 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:60200 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZAEVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:43:06 -0500
Message-ID: <49627E79.3070205@oracle.com>
Date: Mon, 05 Jan 2009 13:41:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH] auditsc: fix kernel-doc notation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49627E83.00F4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auditsc kernel-doc notation:

Warning(linux-2.6.28-git7//kernel/auditsc.c:2156): No description found for parameter 'attr'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2156): Excess function parameter 'u_attr' description in '__audit_mq_open'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2204): No description found for parameter 'notification'
Warning(linux-2.6.28-git7//kernel/auditsc.c:2204): Excess function parameter 'u_notification' description in '__audit_mq_notify'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:	Al Viro <viro@zeniv.linux.org.uk>
cc:	Eric Paris <eparis@redhat.com>
---
 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.28-git7.orig/kernel/auditsc.c
+++ linux-2.6.28-git7/kernel/auditsc.c
@@ -2149,7 +2149,7 @@ int audit_set_loginuid(struct task_struc
  * __audit_mq_open - record audit data for a POSIX MQ open
  * @oflag: open flag
  * @mode: mode bits
- * @u_attr: queue attributes
+ * @attr: queue attributes
  *
  */
 void __audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr)
@@ -2196,7 +2196,7 @@ void __audit_mq_sendrecv(mqd_t mqdes, si
 /**
  * __audit_mq_notify - record audit data for a POSIX MQ notify
  * @mqdes: MQ descriptor
- * @u_notification: Notification event
+ * @notification: Notification event
  *
  */
 
