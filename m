Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZEXNbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZEXNbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 09:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEXNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 09:31:10 -0400
Received: from mout4.freenet.de ([195.4.92.94]:48969 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZEXNbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 09:31:09 -0400
Date: Sun, 24 May 2009 15:30:48 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Use a format for linux_banner
Message-ID: <20090524133047.GA24869@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
References: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com> <49A92783.1010709@s5r6.in-berlin.de> <20090228133602.GA28239@blimp.localdomain> <alpine.LFD.2.00.0902280924150.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902280924150.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no format specifiers left in the linux_banner, and gcc-4.3
complains seeing the printk.

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---

Linus Torvalds, Sat, Feb 28, 2009 18:27:07 +0100:
> What people _can_ do is to send it both as a crazy attachment _and_ as 
> plaintext. If they plaintext gets corrupted, the attachment still works, 
> and the plaintext is at least somethign I can see and thus in my mail 
> reader decide whether it's worth my time to save the attachment and look 
> at it outside the mail reader.

Resent properly. Sorry, took me a while.

 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3bbf93b..d721dad 100644
--- a/init/main.c
+++ b/init/main.c
@@ -566,8 +566,7 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-- 
1.6.3.1.171.ge2f07

