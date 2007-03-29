Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXC2Kql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXC2Kql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030202AbXC2Kql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:46:41 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:25275 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXC2Kqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:46:40 -0400
X-IronPort-AV: i="4.14,345,1170651600"; 
   d="scan'208"; a="25808018:sNHT23704702"
Subject: Re: [PATCH] blackfin arch fix stamp537 ISP1716 IRQ setting bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1175164857.15391.34.camel@roc-desktop>
References: <1175164857.15391.34.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 29 Mar 2007 18:47:32 +0800
Message-Id: <1175165252.15391.40.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for word wrap. this one is ok.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 0f90ff9..a4219df 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -68,7 +68,7 @@ static struct resource bfin_isp1761_resources[] = {
 	[1] = {
 		.start  = ISP1761_IRQ,
 		.end    = ISP1761_IRQ,
-		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+		.flags  = IORESOURCE_IRQ,
 	},
 };
 
-- 
1.5.0.5

