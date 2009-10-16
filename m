Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbZJPOXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbZJPOXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbZJPOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:23:20 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49748 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154AbZJPOXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:23:20 -0400
From: <ilkka.koskinen@nokia.com>
To: <sameo@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 16 Oct 2009 16:21:41 +0200
Subject: RE: [PATCH 1/2] twl4030: Do not dereference null pointer in error
 path
Thread-Topic: [PATCH 1/2] twl4030: Do not dereference null pointer in error
 path
Thread-Index: AcpB4EoHq1gCemUpSdWSDRwu3+3ESgMip6pQ
Message-ID: <F80267346F10C541946CBE8909F1C39E12170A3880@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
In-Reply-To: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Oct 2009 14:21:42.0887 (UTC) FILETIME=[FBF1B770:01CA4E6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Samuel,

What is the status of this patch and the other one:
[PATCH 2/2] twl4030: Enable low-power mode to 32KHz oscillator

Cheers, Ilkka

>-----Original Message-----
>From: Koskinen Ilkka (Nokia-D/Tampere) 
>Sent: 30 September, 2009 18:12
>To: linux-kernel@vger.kernel.org; sameo@linux.intel.com
>Cc: linux-omap@vger.kernel.org; Koskinen Ilkka (Nokia-D/Tampere)
>Subject: [PATCH 1/2] twl4030: Do not dereference null pointer 
>in error path
>
>Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>---
> drivers/mfd/twl4030-core.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
>index e424cf6..8cf0a02 100644
>--- a/drivers/mfd/twl4030-core.c
>+++ b/drivers/mfd/twl4030-core.c
>@@ -792,7 +792,7 @@ twl4030_probe(struct i2c_client *client, 
>const struct i2c_device_id *id)
> 			twl->client = i2c_new_dummy(client->adapter,
> 					twl->address);
> 			if (!twl->client) {
>-				dev_err(&twl->client->dev,
>+				dev_err(&client->dev,
> 					"can't attach client %d\n", i);
> 				status = -ENOMEM;
> 				goto fail;
>-- 
>1.6.0.4
>
>