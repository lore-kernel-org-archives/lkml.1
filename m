Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXLIVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXLIVXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXLIVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:23:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:40554 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXLIVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=l3YbFKFri/yEv13/x8CdknYFcqRo+sMBN0kOxPoFr7QN9JyKB/qKQybcJKH6HALh8z5Jntb5tMpUInrMnhC0699IxWgrjZEGUgmiOA+guYnEdbmyUvr2sDah15kwm+ebzNYkBQGxXEZwJJZlWDLeWcYJ29nrtpE4F0qJz1UzBFw=
Date: Sun, 9 Dec 2007 22:25:09 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usbdevfs_urb: __user annotation
Message-ID: <20071209212505.GB9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbdevfs_urb: __user annotation

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 include/linux/usbdevice_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
index 8ca5a7f..17cb108 100644
--- a/include/linux/usbdevice_fs.h
+++ b/include/linux/usbdevice_fs.h
@@ -104,7 +104,7 @@ struct usbdevfs_urb {
 	int error_count;
 	unsigned int signr;	/* signal to be sent on completion,
 				  or 0 if none should be sent. */
-	void *usercontext;
+	void __user *usercontext;
 	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
 };

