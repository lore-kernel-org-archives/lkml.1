Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZDNJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZDNJoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZDNJkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:40:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23294 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZDNJkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:40:18 -0400
X-IronPort-AV: E=Sophos;i="4.40,183,1238990400"; 
   d="scan'208";a="86232765"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Input: bf54x-keys: Remove depreciated IRQF_SAMPLE_RANDOM flag
Date: Tue, 14 Apr 2009 10:40:10 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0A1CB1DB@limkexm3.ad.analog.com>
In-Reply-To: <1236310491-24387-1-git-send-email-cooloney@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Input: bf54x-keys: Remove depreciated IRQF_SAMPLE_RANDOM flag
Thread-Index: AcmeDDebQ2clX5vzSkG0+rIoEUxhUQe16KTw
References: <1236310491-24387-1-git-send-email-cooloney@kernel.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 14 Apr 2009 09:40:16.0134 (UTC) FILETIME=[043BF260:01C9BCE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>

diff --git a/drivers/input/keyboard/bf54x-keys.c
b/drivers/input/keyboard/bf54x-keys.c
index c6f4e16..73c4481 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -252,7 +252,7 @@ static int __devinit bfin_kpad_probe(struct
platform_device *pdev)
        }

        error = request_irq(bf54x_kpad->irq, bfin_kpad_isr,
-                                IRQF_SAMPLE_RANDOM, DRV_NAME, pdev);
+                                0 , DRV_NAME, pdev);
        if (error) {
                printk(KERN_ERR DRV_NAME
                        ": unable to claim irq %d; error %d\n",

