Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab0BDRVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:52 -0500
Received: from kroah.org ([198.145.64.141]:34632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab0BDRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:39 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:58 2010
Message-Id: <20100204171457.143631497@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mika Westerberg <ext-mika.1.westerberg@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [16/74] UBI: fix volume creation input checking
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>

commit c5ce5b46af76f52dea21f467397d24c4ae6cb3ff upstream.

Do not use an unchecked variable UBI_IOCMKVOL ioctl.

Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/cdev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -853,7 +853,6 @@ static long ubi_cdev_ioctl(struct file *
 			break;
 		}
 
-		req.name[req.name_len] = '\0';
 		err = verify_mkvol_req(ubi, &req);
 		if (err)
 			break;


