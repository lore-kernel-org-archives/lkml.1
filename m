Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYDCNZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYDCNZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbYDCNYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:24:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbYDCNYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=f6Ec43oJ313ZfBdNsvB/8ykAuHzLZ2UlkgRrNNELgQzRRFoa9gQ73B5qWazP4Jrc3BVq4U857i0H6a8YbJVBbPURn/b5A3AYvZry5rnJrh+OdjQZJRCvhHI9frXEXjWNyzINat8xXyvaTq1gcTr7HteoiKrYXeeuA8rP1ifr4yw=
Date: Thu, 3 Apr 2008 17:24:11 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080403132411.GA27017@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403132142.GA26882@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/arm/common/sa1111.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index eb06d0b..282a4d9 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -627,7 +627,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
 	if (!sachip)
 		return -ENOMEM;
 
-	sachip->clk = clk_get(me, "GPIO27_CLK");
+	sachip->clk = clk_get(me, "3_6MHz_CLK");
 	if (!sachip->clk) {
 		ret = PTR_ERR(sachip->clk);
 		goto err_free;
-- 
1.5.4.4


-- 
With best wishes
Dmitry

