Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZBGT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZBGT0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 14:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBGT0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 14:26:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:27840 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZBGT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent;
        b=WTYnvLj8AifPv58VPXV44MbihJqlr3H8Q5PwvJed12/GCG8HKxYB9+SnXtkVMfKqz0
         O6oZrgiC25OFqBXV7G5oB7BKhIOWevQks7Mi3OVLGp+CGxnhLHZL1EzntUWMHOxNA82z
         mGmg6taSPkPZQ52y3Fn4kZSq5DaA0+fcaXc40=
Date: Sat, 7 Feb 2009 20:26:31 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: mdharm-usb@one-eyed-alien.net
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb_storage: make Kconfig note visible in the console
Message-ID: <20090207192631.GA21549@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, mdharm-usb@one-eyed-alien.net,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 7 Feb 2009 20:20:42 +0100
Subject: [PATCH] usb_storage: make Kconfig note visible in the console

Make lines about usb_storage depending on SCSI visible when configuring the
kernel in a 80x25 console

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/usb/storage/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 9df6887..5c36756 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -2,8 +2,8 @@
 # USB Storage driver configuration
 #
 
-comment "NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;"
-comment "see USB_STORAGE Help for more information"
+comment "NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may"
+comment "also be needed; see USB_STORAGE Help for more info"
 	depends on USB
 
 config USB_STORAGE
-- 
1.6.0.3


-- 
Regards/Gruss,
    Boris.
