Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab0BHNCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:02:10 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:49138 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0BHNCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:02:08 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 08 Feb 2010 13:02:05 +0000
From: "L.P. White" <lpw25@cam.ac.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: Add mapping for "AL Network Chat" usage
Message-ID: <Prayer.1.3.2.1002081302050.29006@hermes-2.csi.cam.ac.uk>
X-Mailer: Prayer v1.3.2
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leo P White <lpw25@cam.ac.uk>

Adding a mapping for the 'AL Network Chat' usage from the 'Consumer' usage 
page (USB HID Usage Tables v1.11). This usage is used by some keyboards for 
a multimedia key.

Signed-off-by: Leo P White <lpw25@cam.ac.uk>

---

diff -upNr linux.orig/drivers/hid/hid-input.c 
linux.new/drivers/hid/hid-input.c --- linux.orig/drivers/hid/hid-input.c 
2010-02-06 22:17:12.000000000 +0000 +++ linux.new/drivers/hid/hid-input.c 
2010-02-08 12:32:13.005554190 +0000 @@ -400,6 +400,7 @@ static void 
hidinput_configure_usage(str
 		case 0x192: map_key_clear(KEY_CALC);		break;
 		case 0x194: map_key_clear(KEY_FILE);		break;
 		case 0x196: map_key_clear(KEY_WWW);		break;
+		case 0x199: map_key_clear(KEY_CHAT);		break;
 		case 0x19c: map_key_clear(KEY_LOGOFF);		break;
 		case 0x19e: map_key_clear(KEY_COFFEE);		break;
 		case 0x1a6: map_key_clear(KEY_HELP);		break;
