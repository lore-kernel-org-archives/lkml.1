Return-Path: <linux-kernel-owner+w=401wt.eu-S2992922AbXCIDS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992922AbXCIDS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992921AbXCIDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:18:56 -0500
Received: from ozlabs.org ([203.10.76.45]:45462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992922AbXCIDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:18:56 -0500
Subject: [PATCH 5/9] lguest: documentation fixes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173410210.32234.76.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
	 <1173409939.32234.73.camel@localhost.localdomain>
	 <1173410210.32234.76.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:17:44 +1100
Message-Id: <1173410264.32234.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1: It helps if you connect the bridge to a link.

Signed-off-by: James Morris <jmorris@namei.org>

2: You can theoretically run lguest with no boot parameters.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 90134cf1fe0a Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Wed Feb 21 11:32:59 2007 +1100
+++ b/Documentation/lguest/lguest.c	Wed Feb 21 11:51:47 2007 +1100
@@ -938,7 +938,7 @@ int main(int argc, char *argv[])
 		argc--;
 	}
 
-	if (argc < 4)
+	if (argc < 3)
 		errx(1, "Usage: lguest [--verbose] <mem> vmlinux "
 			"[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)"
 			"|--block=<filename>|--initrd=<filename>]... [args...]");
diff -r 90134cf1fe0a Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt	Wed Feb 21 11:32:59 2007 +1100
+++ b/Documentation/lguest/lguest.txt	Wed Feb 21 11:50:55 2007 +1100
@@ -90,6 +90,7 @@ Running Lguest:
     ifconfig eth0 0.0.0.0
     brctl addbr lg0
     ifconfig lg0 up
+    brctl addif lg0 eth0
     dhclient lg0
     
   Then use --tunnet=bridge:lg0 when launching the guest.


