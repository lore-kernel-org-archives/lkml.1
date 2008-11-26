Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYKZIry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYKZIry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYKZImn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYKZIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=idNsoHs2gPSgglYi96uWPhcBU5HQED5IkRtY0b5kXvYfeKtK9dk1DK0qdx69u4zkN9
         LSF58ue3vDJn/qVEm7bMIRSyj3qDolyL6PAA68nbZPrJASbIA6eiHy59QEljz6jn1Wif
         s9XnDm89mPFeD/tw/D+K/Xaaew1yC3aEE1XdY=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 16/24] perfmon: non-implemented perfmon syscalls
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:39 -0800 (PST)
Message-ID: <492d0bff.1438560a.4e26.ffffbe62@mx.google.com>
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

