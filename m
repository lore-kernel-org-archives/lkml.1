Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0CBHQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 02:16:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:41193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab0CBHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 02:16:12 -0500
Date: Tue, 2 Mar 2010 07:15:41 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de, randy.dunlap@oracle.com
In-Reply-To: <20100301220625.bad46c19.randy.dunlap@oracle.com>
References: <20100301220625.bad46c19.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/doc] x86, docbook: Fix errors from x86 headers merger
Message-ID: <tip-372e22ef0a87d5fc10d387791f9f19721115820c@git.kernel.org>
Git-Commit-ID: 372e22ef0a87d5fc10d387791f9f19721115820c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 07:15:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  372e22ef0a87d5fc10d387791f9f19721115820c
Gitweb:     http://git.kernel.org/tip/372e22ef0a87d5fc10d387791f9f19721115820c
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 1 Mar 2010 22:06:25 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 23:14:33 -0800

x86, docbook: Fix errors from x86 headers merger

Fix docbook errors for x86 headers that were recently merged:

docproc: arch/x86/include/asm/atomic_32.h: No such file or directory
docproc: arch/x86/include/asm/io_32.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <20100301220625.bad46c19.randy.dunlap@oracle.com>
Cc: Brian Gerst <brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/DocBook/device-drivers.tmpl |    2 +-
 Documentation/DocBook/deviceiobook.tmpl   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index f9a6e2c..1b2dd4f 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -45,7 +45,7 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iarch/x86/include/asm/atomic_32.h
+!Iarch/x86/include/asm/atomic.h
 !Iarch/x86/include/asm/unaligned.h
      </sect1>
 
diff --git a/Documentation/DocBook/deviceiobook.tmpl b/Documentation/DocBook/deviceiobook.tmpl
index 3ed8812..c1ed6a4 100644
--- a/Documentation/DocBook/deviceiobook.tmpl
+++ b/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_lock, flags)
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iarch/x86/include/asm/io_32.h
+!Iarch/x86/include/asm/io.h
 !Elib/iomap.c
   </chapter>
 
