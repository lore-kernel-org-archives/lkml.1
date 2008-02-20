Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbYBTSM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbYBTSM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYBTSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:11:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYBTSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:11:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Drop the .data.idt section for FRV
To: torvalds@osdl.org, akpm@linux-foundation.org, gorcunov@gmail.com
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 18:11:39 +0000
Message-ID: <20080220181139.11136.57460.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

There is no .data.idt section for FRV, so drop it from the linker script.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/vmlinux.lds.S |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)


diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 17725a5..b95c4ea 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -76,9 +76,6 @@ SECTIONS
 	  *(.data.init_task)
   }
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(L1_CACHE_BYTES);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 

