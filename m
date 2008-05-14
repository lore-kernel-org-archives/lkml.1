Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYENFhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYENFhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYENFhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:37:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYENFhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:37:04 -0400
Date: Wed, 14 May 2008 01:36:55 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805140536.m4E5atee014300@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] flag parameters: MIPS socket flags
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS defines its own socket types.  So we have to define the new socket
flags and the type mask for MIPS as well.

 socket.h |    7 +++++++
 1 file changed, 7 insertions(+)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/include/asm-mips/socket.h b/include/asm-mips/socket.h
index 63f6025..facc2d7 100644
--- a/include/asm-mips/socket.h
+++ b/include/asm-mips/socket.h
@@ -102,6 +102,13 @@ enum sock_type {
 };
 
 #define SOCK_MAX (SOCK_PACKET + 1)
+/* Mask which covers at least up to SOCK_MASK-1.  The
+ *  * remaining bits are used as flags. */
+#define SOCK_TYPE_MASK 0xf
+
+/* Flags for socket, socketpair, paccept */
+#define SOCK_CLOEXEC	O_CLOEXEC
+#define SOCK_NONBLOCK	O_NONBLOCK
 
 #define ARCH_HAS_SOCKET_TYPES 1
 
