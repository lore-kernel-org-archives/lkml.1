Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZGOCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZGOCVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZGOCVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:21:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55569 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZGOCVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:21:47 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Isaku Yamahata <yamahata@private.email.ne.jp>,
       Jaroslav Kysela <perex@perex.cz>,
       George Hansper <ghansper@apana.org.au>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:51:28 +0530
Message-Id: <20090715022125.4481.17259.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 06/06] Fix compilation warning for sound/drivers/serial/u16550.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following fix is inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/sound/drivers/serial-u16550.c	2009-05-20 10:48:23.000000000 +0530
+++ b/sound/drivers/serial-u16550.c	2009-07-15 06:46:48.000000000 +0530
@@ -902,7 +902,7 @@ static int __devinit snd_uart16550_rmidi
 static int __devinit snd_serial_probe(struct platform_device *devptr)
 {
 	struct snd_card *card;
-	struct snd_uart16550 *uart;
+	struct snd_uart16550 *uninitialized_var(uart);
 	int err;
 	int dev = devptr->id;
 

---
Regards--
Subrata

