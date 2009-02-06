Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZBFFDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZBFFDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 00:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZBFFDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 00:03:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:32834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZBFFDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 00:03:34 -0500
Message-ID: <498BC46D.5080505@kernel.org>
Date: Thu, 05 Feb 2009 21:02:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: [PATCH] forcedeth: enable msix to default
References: <498BC3A8.9040203@kernel.org>
In-Reply-To: <498BC3A8.9040203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: change default

msix and napic can work again

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.orig/drivers/net/forcedeth.c
+++ linux-2.6/drivers/net/forcedeth.c
@@ -862,7 +862,7 @@ enum {
 	NV_MSIX_INT_DISABLED,
 	NV_MSIX_INT_ENABLED
 };
-static int msix = NV_MSIX_INT_DISABLED;
+static int msix = NV_MSIX_INT_ENABLED;
 
 /*
  * DMA 64bit
