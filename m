Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZJPXFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZJPXFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 19:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZJPXFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 19:05:35 -0400
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:46287 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750722AbZJPXFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 19:05:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
Date: Fri, 16 Oct 2009 19:05:37 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24562@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
Thread-Index: AcpOtSySSoRorNueTXq4s/gbfik+yg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Oct 2009 23:05:38.0299 (UTC) FILETIME=[2CE8ECB0:01CA4EB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the following sparse noise:

  warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 34de475..5ca109a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1601,7 +1601,7 @@ int usb_hcd_check_bandwidth(struct usb_device *udev,
 {
 	int num_intfs, i, j;
 	struct usb_interface_cache *intf_cache;
-	struct usb_host_interface *alt = 0;
+	struct usb_host_interface *alt = NULL;
 	int ret = 0;
 	struct usb_hcd *hcd;
 	struct usb_host_endpoint *ep; 
