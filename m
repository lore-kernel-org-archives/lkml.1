Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0CKWG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:06:59 -0500
Received: from mail-px0-f198.google.com ([209.85.216.198]:46862 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab0CKWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:06:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] usb/gadget: fix compile error on r8a66597-udc.c
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Mar 2010 15:06:54 -0700
Message-ID: <20100311220631.19163.98586.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C file uses IS_ERR and PTR_ERR, but doesn't include <linux/err.h>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/usb/gadget/r8a66597-udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 8b45145..5e13d23 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>

