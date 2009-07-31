Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZGaVBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZGaVBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZGaVBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:01:03 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54442 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbZGaVBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:01:02 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] frv: remove unused .altinstructions code
Date: Fri, 31 Jul 2009 16:57:43 -0400
Message-Id: <1249073864-29975-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
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
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/vmlinux.lds.S |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 22d9787..be7a33f 100644
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

