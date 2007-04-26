Return-Path: <linux-kernel-owner+w=401wt.eu-S1031168AbXDZKrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031168AbXDZKrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031171AbXDZKrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:47:08 -0400
Received: from ozlabs.org ([203.10.76.45]:59762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031168AbXDZKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:47:05 -0400
Subject: [PATCH] Fix lguest documentation error
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       James Morris <jmorris@namei.org>
In-Reply-To: <1177584310.30071.60.camel@localhost.localdomain>
References: <1177584310.30071.60.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 20:46:42 +1000
Message-Id: <1177584403.30071.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ How embarrassing, I got the iptables command wrong! --RR ]

From: James Morris <jmorris@namei.org>

Fix up nat example in documentation.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 Documentation/lguest/lguest.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -69,7 +69,7 @@ Running Lguest:
        kernel boot parameters.
 
 - Configuring networking.  I usually have the host masquerade, using
-  "iptables -t nat -o eth0 -j MASQUERADE" and "echo 1 >
+  "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" and "echo 1 >
   /proc/sys/net/ipv4/ip_forward".  In this example, I would configure
   eth0 inside the guest at 192.168.19.2.
 


