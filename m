Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbZKRUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbZKRUj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbZKRUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391AbZKRUj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:39:58 -0500
Date: Wed, 18 Nov 2009 15:40:44 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] ftrace: build ftrace.o when CONFIG_FTRACE_SYSCALLS is set
	for s390
Message-ID: <20091118204044.GR3441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build a s390x kernel with CONFIG_FTRACE_SYSCALLS will fail
because ftrace.o is not built/linked.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 arch/s390/kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- linus-2.6.orig/arch/s390/kernel/Makefile	2009-10-30 17:49:10.000000000 -0400
+++ linus-2.6/arch/s390/kernel/Makefile	2009-11-18 15:39:52.000000000 -0500
@@ -44,6 +44,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(CONFIG_64BIT),mcount64.o,mcount.o)
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
+obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o

