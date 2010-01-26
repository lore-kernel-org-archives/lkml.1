Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683Ab0A0ADf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0A0ADf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995Ab0AZXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:19 -0500
Received: from kroah.org ([198.145.64.141]:35118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0AZXnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:22 2010
Message-Id: <20100126233922.430096741@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>,
       Mark Rosenstand <rosenstand@gmail.com>
Subject: [12/98] Driver-Core: devtmpfs - set root directory mode to 0755
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit 03d673e6af6490371aaf64dfe1f84c658c48b71d upstream.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mark Rosenstand <rosenstand@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/devtmpfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -361,7 +361,7 @@ int __init devtmpfs_init(void)
 		return err;
 	}
 
-	mnt = kern_mount(&dev_fs_type);
+	mnt = kern_mount_data(&dev_fs_type, "mode=0755");
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
 		printk(KERN_ERR "devtmpfs: unable to create devtmpfs %i\n", err);


