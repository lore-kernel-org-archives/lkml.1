Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKSIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKSIz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYKSIzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:55:19 -0500
Received: from host2.marvell.com ([65.219.4.2]:28464 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007AbYKSIzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:55:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/video/backlight/da903x.c: introduce one more missing kfree
Date: Wed, 19 Nov 2008 00:55:14 -0800
Message-ID: <E913911567467945BBEB9277E27868B0014E51CF@msiexch01.marvell.com>
In-Reply-To: <1227084673-10079-1-git-send-email-mike@compulab.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/video/backlight/da903x.c: introduce one more missing kfree
Thread-Index: AclKI/42y9Yz8C62Rha/wJ42cetpGwAAC4tw
References: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk> <1227084673-10079-1-git-send-email-mike@compulab.co.il>
From: "Eric Miao" <ymiao3@marvell.com>
To: "Mike Rapoport" <mike@compulab.co.il>
Cc: <akpm@linux-foundation.org>, <rpurdie@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <rpurdie@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Eric Miao <eric.miao@marvell.com>

Andrew,

Could you please help merge this as well? Thanks.

-----Original Message-----
From: Mike Rapoport [mailto:mike@compulab.co.il] 
Sent: Wednesday, November 19, 2008 4:51 PM
Cc: rpurdie@linux.intel.com; linux-kernel@vger.kernel.org;
kernel-janitors@vger.kernel.org; Eric Miao; Mike Rapoport;
rpurdie@linux.intel.com
Subject: [PATCH] drivers/video/backlight/da903x.c: introduce one more
missing kfree

One more error handling code should have kfree as well

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/da903x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/da903x.c
b/drivers/video/backlight/da903x.c
index 75388b9..93bb434 100644
--- a/drivers/video/backlight/da903x.c
+++ b/drivers/video/backlight/da903x.c
@@ -131,6 +131,7 @@ static int da903x_backlight_probe(struct
platform_device *pdev)
 			data, &da903x_backlight_ops);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
 		return PTR_ERR(bl);
 	}
 
-- 
1.5.6.4

