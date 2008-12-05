Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYLED2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYLED2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYLED2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:28:13 -0500
Received: from vps1.tull.net ([66.180.172.116]:35724 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751558AbYLED2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:28:12 -0500
Mail-From: nobody Fri Dec  5 14:07:57 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH resend#2] Fix incorrect use of loose in vpe.c
To: Jonathan Corbet <corbet@lwn.net>, Lucas Woods <woodzy@gmail.com>,
       Nick Andrew <nick@nick-andrew.net>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:07:57 +1100
Message-ID: <20081205030756.31804.9256.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in vpe.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
I had to resend a few times as lkml was rejecting it.

 arch/mips/kernel/vpe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 972b2d2..a1b3da6 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1134,7 +1134,7 @@ static int vpe_release(struct inode *inode, struct file *filp)
 
 	/* It's good to be able to run the SP and if it chokes have a look at
 	   the /dev/rt?. But if we reset the pointer to the shared struct we
-	   loose what has happened. So perhaps if garbage is sent to the vpe
+	   lose what has happened. So perhaps if garbage is sent to the vpe
 	   device, use it as a trigger for the reset. Hopefully a nice
 	   executable will be along shortly. */
 	if (ret < 0)


