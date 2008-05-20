Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbYETPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbYETPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765398AbYETPa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:27 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbYETPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:26 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: hjk@linutronix.de, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/11] Convert uio to fasync_unlocked
Message-Id: <20080520152853.09CBE1B4205@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:53 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:51.0496 (UTC) FILETIME=[3A844080:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just calls fasync_helper

Cc: hjk@linutronix.de
---
 drivers/uio/uio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/uio/uio.c
===================================================================
--- linux.orig/drivers/uio/uio.c
+++ linux/drivers/uio/uio.c
@@ -541,7 +541,7 @@ static const struct file_operations uio_
 	.read		= uio_read,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
-	.fasync		= uio_fasync,
+	.unlocked_fasync = uio_fasync,
 };
 
 static int uio_major_init(void)
