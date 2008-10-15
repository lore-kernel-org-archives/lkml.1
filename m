Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYJOPvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYJOPvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYJOPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:51:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYJOPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:51:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/7] FRV: Switch unaligned access to the packed-struct
	implementation
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:50:59 +0100
Message-ID: <20081015155058.2158.96559.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
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

