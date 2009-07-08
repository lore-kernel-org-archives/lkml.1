Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZGHQEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZGHQEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZGHQDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:03:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbZGHQD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:03:29 -0400
Subject: [PATCH 24/44] includecheck fix: drivers/net, axnet_cs.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:53:53 +0530
Message-Id: <1247066633.4382.70.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/net/pcmcia/axnet_cs.c: linux/etherdevice.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/pcmcia/axnet_cs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 0e38d80..5a17117 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -893,8 +893,6 @@ static const char version_8390[] = KERN_INFO \
 #include <linux/in.h>
 #include <linux/interrupt.h>
 
-#include <linux/etherdevice.h>
-
 #define BUG_83C690
 
 /* These are the operational function interfaces to board-specific
-- 
1.6.0.6



