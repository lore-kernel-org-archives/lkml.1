Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0BTObS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:31:18 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:56833 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0BTObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=swopywLXNCvCgk4Mi5DLflGOphxAsJG5HqVnVhDdsVN9O7qE+bc7iQpnYkEEKCbg1J
         FTBY4iM6MUDtewD0zFB0ioVXi8nT9eYO9sgSfybI2jCyWCvqI5L/iG1HQG7zLl7cMRpT
         mwCtyvt5a8C5zt6d2iCT2AJdEWZrMEMh4kth4=
Date: Sat, 20 Feb 2010 22:33:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] um: tell git to ignore generated files
Message-ID: <20100220143359.GD3000@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git should ignore these files, since they are generated.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/.gitignore b/.gitignore
index de6344e..efab0eb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,6 +36,7 @@ modules.builtin
 #
 tags
 TAGS
+linux
 vmlinux
 vmlinuz
 System.map
diff --git a/arch/um/.gitignore b/arch/um/.gitignore
new file mode 100644
index 0000000..f22bd73
--- /dev/null
+++ b/arch/um/.gitignore
@@ -0,0 +1,5 @@
+include/shared/kern_constants.h
+include/shared/user_constants.h
+kernel/config.c
+kernel/config.tmp
+kernel/vmlinux.lds

