Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZDOOkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZDOOkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZDOOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:39:58 -0400
Received: from ozlabs.org ([203.10.76.45]:43265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbZDOOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:39:57 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 16 Apr 2009 00:09:52 +0930
Subject: [PATCH 1/3] lguest: document 32-bit and PAE requirements
Cc: lguest@ozlabs.org, "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904160009.53570.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: documentation update

Robert noted that we don't actually document that lguest is 32-bit only,
nor that PAE must be off (CONFIG_PAE is now prompted for if HIGHMEM is
set to "off).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
---
 Documentation/lguest/lguest.txt |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/lguest/lguest.txt b/Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -3,11 +3,11 @@
  /,    /`      - or, A Young Coder's Illustrated Hypervisor
  \\"--\\    http://lguest.ozlabs.org
 
-Lguest is designed to be a minimal hypervisor for the Linux kernel, for
-Linux developers and users to experiment with virtualization with the
-minimum of complexity.  Nonetheless, it should have sufficient
-features to make it useful for specific tasks, and, of course, you are
-encouraged to fork and enhance it (see drivers/lguest/README).
+Lguest is designed to be a minimal 32-bit x86 hypervisor for the Linux kernel,
+for Linux developers and users to experiment with virtualization with the
+minimum of complexity.  Nonetheless, it should have sufficient features to
+make it useful for specific tasks, and, of course, you are encouraged to fork
+and enhance it (see drivers/lguest/README).
 
 Features:
 
@@ -37,6 +37,7 @@ Running Lguest:
      "Paravirtualized guest support" = Y
         "Lguest guest support" = Y
      "High Memory Support" = off/4GB
+     "PAE (Physical Address Extension) Support" = N
      "Alignment value to which kernel should be aligned" = 0x100000
         (CONFIG_PARAVIRT=y, CONFIG_LGUEST_GUEST=y, CONFIG_HIGHMEM64G=n and
          CONFIG_PHYSICAL_ALIGN=0x100000)

