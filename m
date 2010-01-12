Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839Ab0ALBpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0ALBpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934Ab0ALBpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:45:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:8925 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0ALBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KGM3BGO0M/J7X0SU67J9zDZReEjr4UQWuDEstDlNzScxGncuC4BIxs91Lx8Cn5WHpG
         ia2v0vybcflLRuOEpsaZKvZkvuF3XaBnwfiz9cmYa5Xvqn71bH+hv+MFtDc8lqHeqHXc
         aqFV6XcbRRom0OTLA6Cf0z4VsQCzilzlgd4pE=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Duncan Sands <duncan.sands@free.fr>, Greg Kroah-Hartman <gregkh@suse.de>,
       Thiago Farina <tfransosi@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH] usb/atm: Use FIELD_SIZEOF, trivial cleanup.
Date: Mon, 11 Jan 2010 20:45:26 -0500
Message-Id: <d767f149129db30232bb202a6faf6928ad8977fc.1263260509.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.103.g699d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/usb/atm/usbatm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index fbea856..e78d735 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1348,7 +1348,7 @@ static int __init usbatm_usb_init(void)
 {
 	dbg("%s: driver version %s", __func__, DRIVER_VERSION);
 
-	if (sizeof(struct usbatm_control) > sizeof(((struct sk_buff *) 0)->cb)) {
+	if (sizeof(struct usbatm_control) > FIELD_SIZEOF(struct sk_buff, cb)) {
 		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
 		return -EIO;
 	}
-- 
1.6.6.103.g699d2

