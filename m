Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYDNOTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYDNOTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbYDNOSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:18:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41770 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155AbYDNOSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:05 -0400
Date: Mon, 14 Apr 2008 17:16:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080414141659.GF6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
availability of an asm/ide.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8b22281..519b4ff 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,7 +38,6 @@ config PCMCIA_DEBUG
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
-	select HAVE_IDE
 	default y
 	---help---
 	   This option enables support for 16-bit PCMCIA cards. Most older

