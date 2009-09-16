Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbZIPQmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbZIPQmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbZIPQlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:41:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39342 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759780AbZIPQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:41:48 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH v2 1/2] frv: remove unused .altinstructions code
Date: Wed, 16 Sep 2009 12:41:28 -0400
Message-Id: <1253119289-19261-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119289-19261-1-git-send-email-tabbott@ksplice.com>
References: <1253119289-19261-1-git-send-email-tabbott@ksplice.com>
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
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: David Howells <dhowells@redhat.com>
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

