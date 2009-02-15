Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZBOUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZBOUA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZBOUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:00:48 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:39827 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZBOUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:00:47 -0500
Message-ID: <49987469.5070302@oracle.com>
Date: Sun, 15 Feb 2009 12:00:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH PWC: fix build error when CONFIG_INPUT=m
References: <20090208145835.GA1649@elte.hu> <200902111247.39922.laurent.pinchart@skynet.be> <20090211105600.32eefe7b@pedra.chehab.org> <200902150119.48355.laurent.pinchart@skynet.be>
In-Reply-To: <200902150119.48355.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49987442.00B1:SCFSTAT928724,ss=1,fgs=0
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
