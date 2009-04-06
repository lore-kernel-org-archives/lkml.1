Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbZDFWCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbZDFWCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbZDFV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:58:22 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40574 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760920AbZDFV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:58:21 -0400
Date: Mon, 6 Apr 2009 14:57:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH resend] UVC: uvc_status_cleanup(): undefined reference to
 `input_unregister_device'
Message-Id: <20090406145755.8879e292.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49DA7ADC.00B0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when USB_VIDEO_CLASS=y and INPUT=m.
Fixes kernel bugzilla #12671.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0214-0049.orig/drivers/media/video/uvc/Kconfig
+++ mmotm-2009-0214-0049/drivers/media/video/uvc/Kconfig
@@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
-	depends on USB_VIDEO_CLASS && INPUT
+	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
 	---help---
 	  This option makes USB Video Class devices register an input device
 	  to report button events.

