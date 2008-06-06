Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbYFFPDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbYFFPDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbYFFPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:03:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:48727 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757770AbYFFPDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:03:05 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19c7SpE8oZc+be+LZopYMWx85gXIHDIsclqyGjtkx
	9ZZ1A6yFnBfhgd
Date: Fri, 6 Jun 2008 17:02:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: perex@perex.cz
Subject: [PATCH] ac97: add support for wm9711 master left inv switch
Message-ID: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Beisert <j.beisert@pengutronix.de>

This patch adds support for Master Left Inv Switch on wm9711.
At least required to drive the mono speaker on the PXA270 platfrom

Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>

---

 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/sound/pci/ac97/ac97_patch.c
===================================================================
--- linux-2.6.orig/sound/pci/ac97/ac97_patch.c	2008-05-26 12:19:23.000000000 +0200
+++ linux-2.6/sound/pci/ac97/ac97_patch.c	2008-05-27 13:23:11.000000000 +0200
@@ -669,6 +669,7 @@
 AC97_SINGLE("Mic 2 Volume", AC97_MIC, 0, 31, 1),
 AC97_SINGLE("Mic 20dB Boost Switch", AC97_MIC, 7, 1, 0),
 
+AC97_SINGLE("Master Left Inv Switch", AC97_MASTER, 6, 1, 0),
 AC97_SINGLE("Master ZC Switch", AC97_MASTER, 7, 1, 0),
 AC97_SINGLE("Headphone ZC Switch", AC97_HEADPHONE, 7, 1, 0),
 AC97_SINGLE("Mono ZC Switch", AC97_MASTER_MONO, 7, 1, 0),

