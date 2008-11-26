Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYKZPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYKZPFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYKZPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:05:38 -0500
Received: from fias.uni-frankfurt.de ([141.2.248.1]:41630 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYKZPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:05:37 -0500
From: Jan Scholz <Scholz@fias.uni-frankfurt.de>
To: jkosina@suse.cz
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>
Subject: [PATCH 0/1] HID: hid_apple is not used for apple alu wireless keyboards
Date: Wed, 26 Nov 2008 15:33:44 +0100
Message-Id: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

While parsing 'hid_blacklist' in hid-core.c my apple alu wireless
keyboard is not found.  This happens because in the blacklist it
is declared with HID_USB_DEVICE although the keyboards are really
bluetooth devices.  The same holds for 'apple_devices' list in
hid-apple.c

This patch fixes it by changing HID_USB_DEVICE to
HID_BLUETOOTH_DEVICE in those two lists.

Jan Scholz (1):
  HID: Apple alu wireless keyboards are bluetooth devices

 drivers/hid/hid-apple.c |    6 +++---
 drivers/hid/hid-core.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

