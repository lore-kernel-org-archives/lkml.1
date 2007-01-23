Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXAWPRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXAWPRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXAWPRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:17:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:2278 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967AbXAWPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:17:50 -0500
Date: Tue, 23 Jan 2007 16:17:56 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Giuliano Pochini <pochini@shiny.it>, perex@suse.cz
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] echo3g_dsp.c shouldn't include #include <linux/irq.h>
Message-ID: <20070123151756.GH9093@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Despite being under linux/, linux/irq.h shouldn't be #include'd by arch 
independent code.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc4-mm1/sound/pci/echoaudio/echo3g_dsp.c.old	2007-01-23 15:16:37.000000000 +0100
+++ linux-2.6.20-rc4-mm1/sound/pci/echoaudio/echo3g_dsp.c	2007-01-23 14:22:49.000000000 +0100
@@ -39,7 +39,7 @@
 static int write_control_reg(struct echoaudio *chip, u32 ctl, u32 frq,
 			     char force);
 
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 
 static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {


