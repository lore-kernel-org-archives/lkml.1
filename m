Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZJVPa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZJVPa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZJVPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:30:29 -0400
Received: from xenotime.net ([72.52.64.118]:33712 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755597AbZJVPa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:30:28 -0400
Date: Thu, 22 Oct 2009 08:30:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] doc: SubmitChecklist, add ioctls, remove OSDL reference
Message-Id: <20091022083027.8b3473e7.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

If a patch adds ioctls, then Documentation/ioctl/ioctl-number.txt
should also be updated.

Remove reference to the OSDL PLM build farm.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmitChecklist |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- lnx-2632-rc5.orig/Documentation/SubmitChecklist
+++ lnx-2632-rc5/Documentation/SubmitChecklist
@@ -15,7 +15,7 @@ kernel patches.
 2: Passes allnoconfig, allmodconfig
 
 3: Builds on multiple CPU architectures by using local cross-compile tools
-   or something like PLM at OSDL.
+   or some other build farm.
 
 4: ppc64 is a good architecture for cross-compilation checking because it
    tends to use `unsigned long' for 64-bit quantities.
@@ -88,3 +88,6 @@ kernel patches.
 
 24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
     source code that explains the logic of what they are doing and why.
+
+25: If any ioctl's are added by the patch, then also update
+    Documentation/ioctl/ioctl-number.txt.
---
~Randy
