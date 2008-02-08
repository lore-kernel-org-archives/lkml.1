Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYBHWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYBHWDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYBHWDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:03:13 -0500
Received: from opcao.uece.br ([200.129.22.45]:55423 "EHLO opcao.uece.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYBHWDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:03:12 -0500
Message-ID: <47ACD103.8000801@uece.br>
Date: Fri, 08 Feb 2008 19:00:35 -0300
From: Sergio Luis <sergio@uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.24-git19 fs/smbfs/inode.c - fix warning message deprecating
 smbfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just fixes the warning message regarding smbfs to 
"smbfs is deprecated and will be removed from the 2.6.27 kernel. Please migrate to cifs"
instead of 
"smbfs is deprecated and will be removedfrom the 2.6.27 kernel.  Please migrate to cifs"

(adding a blank space between 'removed' and 'from' and removing one between the dot and 'Please')

Signed-off-by: Sergio Luis <sergio@uece.br>


inode.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -urN linux-2.6.24-git19.orig/fs/smbfs/inode.c linux-2.6.24-git19/fs/smbfs/inode.c
--- linux-2.6.24-git19.orig/fs/smbfs/inode.c	2008-02-08 18:42:21.000000000 -0300
+++ linux-2.6.24-git19/fs/smbfs/inode.c	2008-02-08 18:34:45.000000000 -0300
@@ -505,7 +505,7 @@
 	if (warn_count < 5) {
 		warn_count++;
 		printk(KERN_EMERG "smbfs is deprecated and will be removed"
-			"from the 2.6.27 kernel.  Please migrate to cifs\n");
+			" from the 2.6.27 kernel. Please migrate to cifs\n");
 	}
 
 	if (!raw_data)
