Return-Path: <linux-kernel-owner+w=401wt.eu-S1946550AbXBIPnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946550AbXBIPnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946589AbXBIPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:43:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556AbXBIPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f2n7fpwS+20SV6vl615Re3AAlH+C7zKOxlyGJLIlx80NdeA4KfTRb5M+bJLn56Atb3qj3920+fWZunbPgzKiw/+N3m+pQ4sxsW5xEz2JGPKN7HD0/JsAQ1tHg/eLHGfAckCxjZVUu7atfj3wYke+TG4nkzrefpo1dVD0Dir7iRY=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, uclinux-v850@lsi.nec.co.jp
Subject: [PATCH 17/34] __initdata cleanup - v850
Date: Fri, 9 Feb 2007 17:23:48 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091723.48660.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/v850/kernel/setup.c linux-2.6.20-rc6-mm3/arch/v850/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/v850/kernel/setup.c	2007-01-31 22:15:32.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/v850/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -42,7 +42,7 @@ extern char _root_fs_image_start __attri
 extern char _root_fs_image_end __attribute__ ((__weak__));
 
 
-char __initdata command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 /* Memory not used by the kernel.  */
 static unsigned long total_ram_pages;
