Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYJNMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYJNMdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYJNMc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:32:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbYJNMc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:32:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Switch unaligned access to the packed-struct
	implementation
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, harvey.harrison@gmail.com,
       linux-kernel@vger.kernel.org
Date: Tue, 14 Oct 2008 13:32:52 +0100
Message-ID: <20081014123252.8709.7734.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Switch unaligned access to the packed-struct implementation for BE accesses as
this reduces the size of the kernel a little.  LE still uses the byte shift.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 839a2fb..6c61c05 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -13,7 +13,7 @@
 #define _ASM_UNALIGNED_H
 
 #include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/generic.h>
 
 #define get_unaligned	__get_unaligned_be

