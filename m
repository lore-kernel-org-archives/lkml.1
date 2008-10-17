Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYJQPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYJQPK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbYJQPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:1663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbYJQPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=EQ+kIKCyic8ZvXh0HjbIqzy8mSvZIFm6AzAJJfYJhVAIGxgAoGlxNTUPZQXmAY7rX8
         3VvNC5sdPsph1YR9dm1YIY+XFjqi9V8gjhZyrGerjh/aQ5YJXuZukshswwqpW9m1Dg61
         fdh6qjOfjaj8BGr3MNYiJN5ODVzVEVO1kkhU0=
To: linux-kernel@vger.kernel.org
Subject: [patch 16/24] perfmon3:  non-implemented perfmon syscalls
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:49 -0700 (PDT)
Message-ID: <48f8a9cd.11355e0a.25a7.14c2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the conditional perfmon syscalls, i.e.,
the non-implemented syscalls. This is a generic patch
for al architectures. It must be applied before any
syscall table is populated.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/kernel/sys_ni.c
===================================================================
--- o3.orig/kernel/sys_ni.c	2008-10-10 11:07:00.000000000 +0200
+++ o3/kernel/sys_ni.c	2008-10-10 11:29:08.000000000 +0200
@@ -168,3 +168,10 @@
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+
+/* perfmon */
+cond_syscall(sys_pfm_create);
+cond_syscall(sys_pfm_write);
+cond_syscall(sys_pfm_read);
+cond_syscall(sys_pfm_attach);
+cond_syscall(sys_pfm_set_state);

-- 

