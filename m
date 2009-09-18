Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZIRTx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZIRTx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZIRTxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:53:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41592 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbZIRTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:53:52 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 1/3] frv: remove unused .altinstructions code
Date: Fri, 18 Sep 2009 15:52:07 -0400
Message-Id: <1253303529-6342-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253303529-6342-1-git-send-email-tabbott@ksplice.com>
References: <1253303529-6342-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

It appears that frv copied the .altinstructions definitions in its linker
script from x86. Since frv doesn't put anything in those sections, this
is just dead code.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/frv/kernel/vmlinux.lds.S |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 7dbf41f..cfb4181 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -51,11 +51,6 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
-  . = ALIGN(4);
-  __alt_instructions = .;
-  .altinstructions : { *(.altinstructions) }
-  __alt_instructions_end = .;
- .altinstr_replacement : { *(.altinstr_replacement) }
 
   PERCPU(4096)
 
-- 
1.6.3.3

