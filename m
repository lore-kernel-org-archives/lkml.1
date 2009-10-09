Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbZJIXMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbZJIXMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbZJIXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:12:15 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:23041 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZJIXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:12:14 -0400
Date: Fri, 9 Oct 2009 16:10:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Howells <dhowells@redhat.com>
Subject: [PATCH -mmotm] synchro-test: add missing header file
Message-Id: <20091009161042.b301700c.randy.dunlap@oracle.com>
In-Reply-To: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACFC311.00FC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors, add <sched.h> header file:

kernel/synchro-test.c: In function 'sched':
kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
kernel/synchro-test.c: In function 'mutexer':
kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'semaphorer':
kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'reader':
kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'writer':
kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'downgrader':
kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/synchro-test.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-1009-0107.orig/kernel/synchro-test.c
+++ mmotm-2009-1009-0107/kernel/synchro-test.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <asm/atomic.h>
