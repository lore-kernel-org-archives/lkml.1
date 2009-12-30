Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZL3MHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZL3MHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZL3MHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:07:41 -0500
Received: from zmc.proxad.net ([212.27.53.206]:51712 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZL3MHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:07:41 -0500
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Dec 2009 07:07:41 EST
X-Spam-Flag: NO
X-Spam-Score: -3.923
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
To: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] ignore vmlinuz
Date: Wed, 30 Dec 2009 12:53:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-server; KDE/4.3.2; x86_64; ; )
Cc: linux-mips@linux-mips.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912301253.44057.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS compressed kernels output a vmlinuz file in the
top-level directory (maybe others do).
Add vmlinuz to the list of files to ignore by git.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
diff --git a/.gitignore b/.gitignore
index fb2190c..de6344e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -37,6 +37,7 @@ modules.builtin
 tags
 TAGS
 vmlinux
+vmlinuz
 System.map
 Module.markers
 Module.symvers


