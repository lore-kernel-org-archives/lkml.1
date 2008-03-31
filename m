Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYCaIqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYCaIqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYCaIpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:45:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:35092 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYCaIpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pLSXN8N0CsP/OZ7JdogAFx58564X4PYrhJ03i9GSFudoKsIJqzZIct5r4lxAXzvpnptKYc3+lc9bjUHBYMH6TK9DkUj2s9pYDPprYe1ctd94Ld3FPYIpfXRvO4YBr573FJY02QgbPxnGuNSO8rg7/E+xUSwb1RbeD24sdJ87wZY=
Date: Mon, 31 Mar 2008 12:45:04 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-ID: <20080331084504.GA11671@doriath.ww600.siemens.net>
References: <20080331083947.GA11282@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331083947.GA11282@doriath.ww600.siemens.net>
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

