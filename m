Return-Path: <linux-kernel-owner+w=401wt.eu-S940469AbXGUPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940469AbXGUPL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939426AbXGUPEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbXGUPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=MS8YIssnt6p09W5aO2RrCwiQxwucXB125dE1PV1u5aUq4wCAgluELRstn8kEJyolEZMd9pc9/XtclPWW6UEWOg0wNP+K1yb07c6BOTTyGdfAtXNBXBV4Ok3b15IOhadp7wdoTXPQW/9bA259tBKX/FsjQGGk+Uvk3wiE2gZ11GU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][17/37] Clean up duplicate includes in fs/
Date: Sat, 21 Jul 2007 17:03:02 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Jakub Jelinek <jakub@redhat.com>,
       Eddie C Dost <ecd@skynet.be>, Andi Kleen <ak@suse.de>,
       Theodore Tso <tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.02653.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	fs/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index e440a7b..d3208db 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -113,7 +113,6 @@
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/video.h>
-#include <linux/lp.h>
 
 static int do_ioctl32_pointer(unsigned int fd, unsigned int cmd,
 			      unsigned long arg, struct file *f)
diff --git a/fs/namei.c b/fs/namei.c
index a83160a..2dbd8a2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -30,7 +30,6 @@
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
-#include <linux/namei.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
