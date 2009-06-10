Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZFJNoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZFJNoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZFJNoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:44:03 -0400
Received: from server3.xboxworld.nl ([80.247.163.60]:40436 "EHLO
	server3.xboxworld.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZFJNoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:44:02 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2009 09:44:02 EDT
From: Jorrit Schippers <jorrit@ncode.nl>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jorrit Schippers <jorrit@ncode.nl>
Subject: [PATCH 1/1] rt2870: Add USB ID for Sitecom WL-608
Date: Wed, 10 Jun 2009 15:34:26 +0200
Message-Id: <1244640866-21385-1-git-send-email-jorrit@ncode.nl>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the USB id 0x0DF6,0x003F to the rt2870.h file such that the
Sitecom WL-608 device will be recognized by this driver.

Signed-off-by: Jorrit Schippers <jorrit@ncode.nl>
---
 drivers/staging/rt2870/rt2870.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2870/rt2870.h b/drivers/staging/rt2870/rt2870.h
index a69cf33..fef14a4 100644
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -97,6 +97,7 @@
 	{USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */		\
+	{USB_DEVICE(0x0DF6,0x003F)}, /* Sitecom WL-608 */	\
 	{USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */		\
 	{USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */		\
 	{USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */		\
-- 
1.6.0.4

