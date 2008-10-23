Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYJWAQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYJWAQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYJWAQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:16:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53384 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbYJWAQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:16:31 -0400
Message-ID: <48FFC22A.2040508@oracle.com>
Date: Wed, 22 Oct 2008 17:15:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: remove excess kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Delete excess kernel-doc notation in kernel/auditsc.c:

Warning(linux-2.6.27-git10//kernel/auditsc.c:1481): Excess function parameter or struct member 'tsk' description in 'audit_syscall_entry'
Warning(linux-2.6.27-git10//kernel/auditsc.c:1564): Excess function parameter or struct member 'tsk' description in 'audit_syscall_exit'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Eric Paris <eparis@redhat.com>
---
 kernel/auditsc.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.27-git10.orig/kernel/auditsc.c
+++ linux-2.6.27-git10/kernel/auditsc.c
@@ -1459,7 +1459,6 @@ void audit_free(struct task_struct *tsk)
 
 /**
  * audit_syscall_entry - fill in an audit record at syscall entry
- * @tsk: task being audited
  * @arch: architecture type
  * @major: major syscall type (function)
  * @a1: additional syscall register 1
@@ -1550,7 +1549,6 @@ void audit_syscall_entry(int arch, int m
 
 /**
  * audit_syscall_exit - deallocate audit context after a system call
- * @tsk: task being audited
  * @valid: success/failure flag
  * @return_code: syscall return value
  *

