Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935290Ab0CMBOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:14:10 -0500
Received: from kroah.org ([198.145.64.141]:46597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935315Ab0CMAae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:34 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.836357664@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [007/145] V4L/DVB: cxusb: Select all required frontend and tuner modules
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Ben Hutchings <ben@decadent.org.uk>

commit fc4a7f93087a48619005111895dcaa115f807399 upstream.

cxusb uses the atbm8830 and lgs8gxx (not lgs8gl5) frontends and the
max2165 tuner, so it needs to select them.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -112,11 +112,13 @@ config DVB_USB_CXUSB
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_LGS8GL5 if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
+	select DVB_ATBM8830 if !DVB_FE_CUSTOMISE
+	select DVB_LGS8GXX if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MAX2165 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Conexant USB2.0 hybrid reference design.
 	  Currently, only DVB and ATSC modes are supported, analog mode


