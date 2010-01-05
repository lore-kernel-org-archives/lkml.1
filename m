Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630Ab0AEUJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0AEUJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439Ab0AEUJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:09:37 -0500
Received: from kroah.org ([198.145.64.141]:50042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab0AEUGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:02 2010
Message-Id: <20100105200302.623292838@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
       Douglas Schilling Landgraf <dougsland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Brandon Philips <brandon@ifup.org>
Subject: [28/39] V4L/DVB (13596): ov511.c typo: lock => unlock
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 50e9d31183ed61c787b870cb3ee8f6c3db8c8a1e upstream.

This was found with a static checker and has not been tested, but it seems
pretty clear that the mutex_lock() was supposed to be mutex_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Brandon Philips <brandon@ifup.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ov511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5878,7 +5878,7 @@ ov51x_probe(struct usb_interface *intf, 
 		goto error;
 	}
 
-	mutex_lock(&ov->lock);
+	mutex_unlock(&ov->lock);
 
 	return 0;
 


