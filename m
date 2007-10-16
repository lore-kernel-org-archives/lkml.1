Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbXJPHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbXJPHU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbXJPHUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:20:14 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:51748 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761717AbXJPHUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:20:13 -0400
Date: Tue, 16 Oct 2007 11:22:21 +0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: den@openvz.org, linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore update for x86 arch
Message-ID: <20071016072221.GA14029@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
- makes .gitignore files visible to git
- makes arch/x86/kernel/vsyscall_32.lds and arch/i386/boot invisible

Signed-off-by: Denis V. Lunev <den@openvz.org>

diff --git a/.gitignore b/.gitignore
index 27c3e83..22fb8fa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -26,6 +26,7 @@ vmlinux*
 !vmlinux.lds.S
 System.map
 Module.symvers
+!.gitignore
 
 #
 # Generated include files
diff --git a/arch/i386/.gitignore b/arch/i386/.gitignore
new file mode 100644
index 0000000..36ef4c3
--- /dev/null
+++ b/arch/i386/.gitignore
@@ -0,0 +1 @@
+boot
diff --git a/arch/x86/kernel/.gitignore b/arch/x86/kernel/.gitignore
index 40836ad..4ea38a3 100644
--- a/arch/x86/kernel/.gitignore
+++ b/arch/x86/kernel/.gitignore
@@ -1 +1,2 @@
 vsyscall.lds
+vsyscall_32.lds
