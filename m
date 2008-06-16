Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYFPBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYFPBp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYFPBpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:45:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:58174 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYFPBpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:45:15 -0400
Message-ID: <4855C599.5010602@devslashzero.com>
Date: Mon, 16 Jun 2008 07:14:57 +0530
From: Abhijit Bhopatkar <bain@devslashzero.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: [PATCH] DVB-USB UMT-010 driver oops on install
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize stream count using MAX_NO_URBS_FOR_DATA_STREAM.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Abhijit Bhopatkar <bain@devslashzero.com>
---
 drivers/media/dvb/dvb-usb/umt-010.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/umt-010.c
b/drivers/media/dvb/dvb-usb/umt-010.c
index 9e7653b..118aab1 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -107,7 +107,7 @@ static struct dvb_usb_device_properties
umt_properties = {
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_BULK,
-				.count = 20,
+				.count = MAX_NO_URBS_FOR_DATA_STREAM,
 				.endpoint = 0x06,
 				.u = {
 					.bulk = {
-- 1.5.5.29.g7134
