Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0BCRZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:25:02 -0500
Received: from bu3sch.de ([62.75.166.246]:42965 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab0BCRY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:24:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix CONFIG_SSB_SDIOHOST typo
Date: Wed, 3 Feb 2010 18:24:35 +0100
User-Agent: KMail/1.9.9
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       albert_herranz@yahoo.es, vamos@i4.informatik.uni-erlangen.de,
       linux-kernel@vger.kernel.org
References: <20100203152322.GA7167@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100203152322.GA7167@faui49.informatik.uni-erlangen.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201002031824.37215.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a CONFIG_SSB_SDIOHOST typo.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

---
 drivers/ssb/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -494,8 +494,7 @@ static int ssb_devices_register(struct s
 #endif
 			break;
 		case SSB_BUSTYPE_SDIO:
-#ifdef CONFIG_SSB_SDIO
-			sdev->irq = bus->host_sdio->dev.irq;
+#ifdef CONFIG_SSB_SDIOHOST
 			dev->parent = &bus->host_sdio->dev;
 #endif
 			break;

-- 
Greetings, Michael.
