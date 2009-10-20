Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZJTNTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZJTNTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZJTNTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:19:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23256 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZJTNTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:19:41 -0400
From: <ilkka.koskinen@nokia.com>
To: <sameo@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 20 Oct 2009 15:19:20 +0200
Subject: RE: [PATCH 1/2] twl4030: Do not dereference null pointer in error
 path
Thread-Topic: [PATCH 1/2] twl4030: Do not dereference null pointer in error
 path
Thread-Index: AcpQ0/HID5cFA177TgS0bCEDfi8vSwAsyLPQ
Message-ID: <F80267346F10C541946CBE8909F1C39E121710C56C@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
 <F80267346F10C541946CBE8909F1C39E12170A3880@NOK-EUMSG-02.mgdnok.nokia.com>
 <20091019155230.GF3885@sortiz.org>
In-Reply-To: <20091019155230.GF3885@sortiz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Oct 2009 13:19:31.0938 (UTC) FILETIME=[F5C71420:01CA5187]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Samuel,

>From: ext Samuel Ortiz [mailto:sameo@linux.intel.com] 
>Sent: 19 October, 2009 18:53
>On Fri, Oct 16, 2009 at 04:21:41PM +0200, 
>ilkka.koskinen@nokia.com wrote:
>> 
>> Hi Samuel,
>> 
>> What is the status of this patch and the other one:
>> [PATCH 2/2] twl4030: Enable low-power mode to 32KHz oscillator
>I'm sorry but it seems I havent received those 2 patches. 
>Could you please
>re-send them ?

Sorry, my mistake. I already forgot that the patches never
reached you. I'll resend them right away.

Cheers, Ilkka

>> >-----Original Message-----
>> >From: Koskinen Ilkka (Nokia-D/Tampere) 
>> >Sent: 30 September, 2009 18:12
>> >To: linux-kernel@vger.kernel.org; sameo@linux.intel.com
>> >Cc: linux-omap@vger.kernel.org; Koskinen Ilkka (Nokia-D/Tampere)
>> >Subject: [PATCH 1/2] twl4030: Do not dereference null pointer 
>> >in error path
>> >
>> >Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>> >---
>> > drivers/mfd/twl4030-core.c |    2 +-
>> > 1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> >diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
>> >index e424cf6..8cf0a02 100644
>> >--- a/drivers/mfd/twl4030-core.c
>> >+++ b/drivers/mfd/twl4030-core.c
>> >@@ -792,7 +792,7 @@ twl4030_probe(struct i2c_client *client, 
>> >const struct i2c_device_id *id)
>> > 			twl->client = i2c_new_dummy(client->adapter,
>> > 					twl->address);
>> > 			if (!twl->client) {
>> >-				dev_err(&twl->client->dev,
>> >+				dev_err(&client->dev,
>> > 					"can't attach client %d\n", i);
>> > 				status = -ENOMEM;
>> > 				goto fail;
>> >-- 
>> >1.6.0.4
>> >
>> >
>
>-- 
>Intel Open Source Technology Centre
>http://oss.intel.com/
>