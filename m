Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZDFWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZDFWDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760446AbZDFWAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:00:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:33590 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761161AbZDFV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:59:59 -0400
Date: Mon, 6 Apr 2009 14:59:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH resend] PWC: fix build error when CONFIG_INPUT=m
Message-Id: <20090406145931.c1c843ed.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49DA7B3B.02BE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when USB_PWC=y and INPUT=m.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/pwc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0214-0049.orig/drivers/media/video/pwc/Kconfig
+++ mmotm-2009-0214-0049/drivers/media/video/pwc/Kconfig
@@ -39,7 +39,7 @@ config USB_PWC_DEBUG
 config USB_PWC_INPUT_EVDEV
 	bool "USB Philips Cameras input events device support"
 	default y
-	depends on USB_PWC && INPUT
+	depends on USB_PWC=INPUT || INPUT=y
 	---help---
 	  This option makes USB Philips cameras register the snapshot button as
 	  an input device to report button events.
