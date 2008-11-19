Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYKSPWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYKSPWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYKSPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:22:38 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33292 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752909AbYKSPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:22:38 -0500
Message-ID: <49242F3A.9000007@sgi.com>
Date: Wed, 19 Nov 2008 16:22:34 +0100
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch] docbook build fix, update include path
Content-Type: multipart/mixed;
 boundary="------------070800070402030105080905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800070402030105080905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Build fix for kerneldoc

Jes

--------------070800070402030105080905
Content-Type: text/plain;
 name="0000-fix-docbook-build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0000-fix-docbook-build.patch"

Fix include path for mca_dma.h to match arch/x86/include path

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 Documentation/DocBook/mcabook.xml |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.git/Documentation/DocBook/mcabook.xml
===================================================================
--- linux-2.6.git.orig/Documentation/DocBook/mcabook.xml
+++ linux-2.6.git/Documentation/DocBook/mcabook.xml
@@ -569,7 +569,7 @@
 
   <chapter id="dmafunctions">
      <title>DMA Functions Provided</title>
-<!-- include/asm-x86/mca_dma.h -->
+<!-- arch/x86/include/asm/mca_dma.h -->
 <refentry id="API-mca-enable-dma">
 <refentryinfo>
  <title>LINUX</title>

--------------070800070402030105080905--
