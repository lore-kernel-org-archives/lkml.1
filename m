Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZJSPJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZJSPJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbZJSPJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:09:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:12002 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbZJSPJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:09:08 -0400
X-IronPort-AV: E=Sophos;i="4.44,585,1249272000"; 
   d="scan'208";a="7791043"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mfd: Staticise __adp5520_ack_bits()
Date: Mon, 19 Oct 2009 16:09:07 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E695B8F@limkexm3.ad.analog.com>
In-Reply-To: <1255963582-6796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH] mfd: Staticise __adp5520_ack_bits()
thread-index: AcpQyvTwVYZTHMM2RzKBjAWIID/qygAArZ/Q
References: <1255963582-6796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       "Mike Frysinger" <vapier@gentoo.org>, "Bryan Wu" <cooloney@kernel.org>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Oct 2009 15:09:09.0959 (UTC) FILETIME=[1C2BAD70:01CA50CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>The function is not exported as the __ indicates. __
>
>Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>


Acked-by: Michael Hennerich <michael.hennerich@analog.com>


>---
> drivers/mfd/adp5520.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
>index 401a9b6..b266447 100644
>--- a/drivers/mfd/adp5520.c
>+++ b/drivers/mfd/adp5520.c
>@@ -66,7 +66,8 @@ static int __adp5520_write(struct i2c_client *client,
> 	return 0;
> }
>
>-int __adp5520_ack_bits(struct i2c_client *client, int reg, uint8_t
bit_mask)
>+static int __adp5520_ack_bits(struct i2c_client *client, int reg,
>+			      uint8_t bit_mask)
> {
> 	struct adp5520_chip *chip = i2c_get_clientdata(client);
> 	uint8_t reg_val;
>--
>1.6.5

-Michael
