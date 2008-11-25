Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYKYVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYKYVlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYKYVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:62506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYKYVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=rGEFH3pvFIhMSWAAyO1ItbWTt6BbOuIDQqjQzBEEHjYb2pjGQ6U3AauKS7LeKmwf3l
         2Cp9VERFaUWucrDnqSPfK0gWXzqe/v5f+FwvhVGl7rnY0tqsqmyQ7kLXBECfh9vtWGnJ
         Y7Q3IMPUMKWFr2/Ujnijhr06ajbGqcOxI9JyE=
To: linux-kernel@vger.kernel.org
Subject: [patch 16/24] perfmon: non-implemented perfmon syscalls
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:30 -0800 (PST)
Message-ID: <492c6fde.1f205e0a.16be.ffff8030@mx.google.com>
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
--- o3.orig/kernel/sys_ni.c	2008-11-03 11:35:30.000000000 +0100
+++ o3/kernel/sys_ni.c	2008-11-03 11:35:32.000000000 +0100
@@ -174,3 +174,10 @@
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

