Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXKERQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXKERQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbXKERIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:15 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59535 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757723AbXKERIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:11 -0500
Date: Mon, 5 Nov 2007 18:07:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>, Pete Zaitcev <zaitcev@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] usb/mon/mon_bin.c: cleanups
Message-ID: <20071105170748.GV12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global struct mon_fops_binary static
- #if 0 the unused mon_bin_mmap() and related code

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/mon/mon_bin.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

69e50589713d96e3f26e15ca1ad6360d46281e2b 
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index f06e4e2..81aab52 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1026,6 +1026,8 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+#if 0
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1079,7 +1081,9 @@ int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-struct file_operations mon_fops_binary = {
+#endif  /*  0  */
+
+static struct file_operations mon_fops_binary = {
 	.owner =	THIS_MODULE,
 	.open =		mon_bin_open,
 	.llseek =	no_llseek,

