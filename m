Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZCJQxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZCJQxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZCJQoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:06 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34601 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <3d6d5cb4a350d9202ee4a36c076eaab69c8bdfc8.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:16:04 +0000
Subject: [PATCH 13/31] input: Auto-load mousedev module when /dev/input/mice opened.
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mousedev module is missing the char-major-13-31 alias that would
cause it to be auto-loaded when the /dev/input/mice device is opened.
This patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/input/mousedev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index dfde8ee..a290e90 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -29,6 +29,7 @@
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Mouse (ExplorerPS/2) device interfaces");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV(INPUT_MAJOR, MOUSEDEV_MIX);
 
 #ifndef CONFIG_INPUT_MOUSEDEV_SCREEN_X
 #define CONFIG_INPUT_MOUSEDEV_SCREEN_X	1024
-- 
1.6.0.5

