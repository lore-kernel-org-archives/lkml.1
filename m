Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXCVCaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXCVCaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXCVCaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:30:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38763 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXCVCa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:30:28 -0400
Date: Wed, 21 Mar 2007 19:21:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jkosina@suse.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] ipwireless: use ANSI func. decl.
Message-Id: <20070321192139.15bc0727.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:
drivers/char/pcmcia/ipwireless_cs_tty.c:730:29: warning: non-ANSI function declaration of function 'ipwireless_tty_release'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/pcmcia/ipwireless_cs_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1.orig/drivers/char/pcmcia/ipwireless_cs_tty.c
+++ linux-2.6.21-rc4-mm1/drivers/char/pcmcia/ipwireless_cs_tty.c
@@ -727,7 +727,7 @@ int ipwireless_tty_init(int major)
 	return 0;
 }
 
-void ipwireless_tty_release()
+void ipwireless_tty_release(void)
 {
 	int ret, loops = 0;
 	remove_proc_entry(IPWIRELESS_PCCARD_NAME, &proc_root);
