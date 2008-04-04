Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYDDV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYDDV2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYDDV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:28:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62313 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYDDV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=leSoUU/P6sERWFhwFiu1v+lp+6I9pSKwBHiiayMwfGihAiNkDCWHretZt802BCIeq0z/nIeGgL5iEEfwK35i/uCX9f4kS3ceoR6Xb03sIZcC3OJUHN6oTB4zCAl1M7w9mBQ2Yj+YgsmOihwN3jDtNf4QyYC4C6oIXzOFv98zYm0=
Subject: [PATCH 2/2] usb: replace remaining __PRETTY_FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 14:28:01 -0700
Message-Id: <1207344481.18838.98.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel is written in C, not C++, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/image/microtek.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index bc207e3..75c76f9 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -185,7 +185,7 @@ static struct usb_driver mts_usb_driver = {
 	printk( KERN_DEBUG MTS_NAME x )
 
 #define MTS_DEBUG_GOT_HERE() \
-	MTS_DEBUG("got to %s:%d (%s)\n", __FILE__, (int)__LINE__, __PRETTY_FUNCTION__ )
+	MTS_DEBUG("got to %s:%d (%s)\n", __FILE__, (int)__LINE__, __func__ )
 #define MTS_DEBUG_INT() \
 	do { MTS_DEBUG_GOT_HERE(); \
 	     MTS_DEBUG("transfer = 0x%x context = 0x%x\n",(int)transfer,(int)context ); \
-- 
1.5.5.rc1.135.g8527

