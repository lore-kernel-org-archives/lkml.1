Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZCJQvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZCJQvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZCJQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:01 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34608 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <a52b15c14ef27828bc6d46c7b86fead07bc8422c.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:40:57 +0000
Subject: [PATCH 21/31] video: Auto-load videodev module when device opened.
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The videodev module is missing the char-major-81-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/v4l2-dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 13f87c2..7de7e9a 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -582,6 +582,7 @@ module_exit(videodev_exit)
 MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_DESCRIPTION("Device registrar for Video4Linux drivers v2");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(VIDEO_MAJOR);
 
 
 /*
-- 
1.6.0.5

