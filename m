Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519Ab0AGSly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0AGSly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459Ab0AGSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:40:54 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56844 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0AGSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:52 -0500
Date: Thu, 7 Jan 2010 19:29:48 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 4/7] Input: wacom - Convert remaining ids, part one
Message-ID: <20100107182948.GA12962@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100107182553.GA11236@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom_sys.c |  136 +++++++++++++++++++++++---------------
 1 files changed, 82 insertions(+), 54 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index aa02fb1..26ed62e 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -705,36 +705,64 @@ static struct wacom_features wacom_features[] = {
 	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
 	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
 	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU },
-	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S },
-	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 },
-	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L },
-	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L },
-	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ },
-	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE },
-	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE },
-	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL },
-	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
 	{ }
 };
 
+static struct wacom_features wacom_features_0x41 =
+	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x42 =
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x43 =
+	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x44 =
+	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x45 =
+	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0xB0 =
+	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S };
+static struct wacom_features wacom_features_0xB1 =
+	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB2 =
+	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB3 =
+	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L };
+static struct wacom_features wacom_features_0xB4 =
+	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L };
+static struct wacom_features wacom_features_0xB5 =
+	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 };
+static struct wacom_features wacom_features_0xB7 =
+	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S };
+static struct wacom_features wacom_features_0xB8 =
+	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S };
+static struct wacom_features wacom_features_0xB9 =
+	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 };
+static struct wacom_features wacom_features_0xBA =
+	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L };
+static struct wacom_features wacom_features_0xBB =
+	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L };
+static struct wacom_features wacom_features_0x3F =
+	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ };
+static struct wacom_features wacom_features_0xC5 =
+	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE };
+static struct wacom_features wacom_features_0xC6 =
+	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE };
+static struct wacom_features wacom_features_0xC7 =
+	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL };
+static struct wacom_features wacom_features_0x90 =
+	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x93 =
+	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x9A =
+	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0x9F =
+	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC };
+static struct wacom_features wacom_features_0xE2 =
+	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
+static struct wacom_features wacom_features_0xE3 =
+	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
+static struct wacom_features wacom_features_0x47 =
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+
 #define USB_DEVICE_WACOM(prod) \
 	USB_DEVICE(USB_VENDOR_ID_WACOM,prod), \
 	.driver_info = (uintptr_t)&wacom_features_##prod
@@ -776,33 +804,33 @@ static struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC0) },
 	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC2) },
 	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x03) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x41) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x42) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x43) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x44) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x45) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB0) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB1) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB4) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB8) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB9) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBA) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBB) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x3F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC6) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x90) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x93) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9A) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x47) },
+	{ USB_DEVICE_WACOM(0x41) },
+	{ USB_DEVICE_WACOM(0x42) },
+	{ USB_DEVICE_WACOM(0x43) },
+	{ USB_DEVICE_WACOM(0x44) },
+	{ USB_DEVICE_WACOM(0x45) },
+	{ USB_DEVICE_WACOM(0xB0) },
+	{ USB_DEVICE_WACOM(0xB1) },
+	{ USB_DEVICE_WACOM(0xB2) },
+	{ USB_DEVICE_WACOM(0xB3) },
+	{ USB_DEVICE_WACOM(0xB4) },
+	{ USB_DEVICE_WACOM(0xB5) },
+	{ USB_DEVICE_WACOM(0xB7) },
+	{ USB_DEVICE_WACOM(0xB8) },
+	{ USB_DEVICE_WACOM(0xB9) },
+	{ USB_DEVICE_WACOM(0xBA) },
+	{ USB_DEVICE_WACOM(0xBB) },
+	{ USB_DEVICE_WACOM(0x3F) },
+	{ USB_DEVICE_WACOM(0xC5) },
+	{ USB_DEVICE_WACOM(0xC6) },
+	{ USB_DEVICE_WACOM(0xC7) },
+	{ USB_DEVICE_WACOM(0x90) },
+	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x9A) },
+	{ USB_DEVICE_WACOM(0x9F) },
+	{ USB_DEVICE_WACOM(0xE2) },
+	{ USB_DEVICE_WACOM(0xE3) },
+	{ USB_DEVICE_WACOM(0x47) },
 	{ }
 };
 
-- 
1.6.5.7


-- 
A princess should not be afraid -- not with a brave knight to protect her.
		-- McCoy, "Shore Leave", stardate 3025.3
