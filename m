Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXL1Vzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXL1Vzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXL1Vzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:55:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:49160 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXL1Vzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CLDGt6Nmm4BTThCI2/cbbiye36/5MiUOoMV0bxQneYyTM+nE/DeqBxyJgGp2MNFblPc6i+9O0ZJy4ZvXhjhDYytH+YeaN70cLyHlu+cOdj7AQ0BpJx/rJinaxI0RA5+W4QvalpZLi5W2rD1YedgF3kHsJaDk3OzvtwLNIa8H5wY=
Message-ID: <813cedd60712281355w3586f08fo97bfdf5dbcea0a0a@mail.gmail.com>
Date: Fri, 28 Dec 2007 22:55:38 +0100
From: "=?ISO-8859-1?Q?Daniel_Koz=E1k?=" <kozzi11@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: remove duplicate entry in option.c and pl2303.h - linux-2.6.23.12
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kozák <kozzi11@gmail.com>

Remove entry for Huawei E620 UMTS/HSDPA card (ID: 12d1:1001)
Option driver is use instead
Signed-off-by: Daniel Kozák <kozzi11@gmail.com>
---
--- linux-2.6/drivers/usb/serial/pl2303.h.orig  2007-12-28
22:11:13.000000000 +0100
+++ linux-2.6/drivers/usb/serial/pl2303.h       2007-12-28
22:11:48.000000000 +0100
@@ -94,9 +94,6 @@
 #define ALCOR_VENDOR_ID                0x058F
 #define ALCOR_PRODUCT_ID       0x9720

-/* Huawei E620 UMTS/HSDPA card (ID: 12d1:1001) */
-#define HUAWEI_VENDOR_ID       0x12d1
-#define HUAWEI_PRODUCT_ID      0x1001

 /* Willcom WS002IN Data Driver (by NetIndex Inc.) */
 #define WS002IN_VENDOR_ID      0x11f6
