Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZG2ABy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZG2ABy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZG1Xto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:44 -0400
Received: from kroah.org ([198.145.64.141]:35665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZG1Xtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:53 2009
Message-Id: <20090728234153.049587639@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [patch 12/71] USB: fix uninitialised variable in ti_do_download
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=usb-fix-uninitialised-variable-in-ti_do_download.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 87ea8c887905d8b13ae90b537117592ed027632a upstream.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1659,7 +1659,7 @@ static int ti_do_download(struct usb_dev
 	u8 cs = 0;
 	int done;
 	struct ti_firmware_header *header;
-	int status;
+	int status = 0;
 	int len;
 
 	for (pos = sizeof(struct ti_firmware_header); pos < size; pos++)


