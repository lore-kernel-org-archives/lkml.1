Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbZJSPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbZJSPuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbZJSPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:50:51 -0400
Received: from mga06.intel.com ([134.134.136.21]:13650 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932205AbZJSPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:50:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,585,1249282800"; 
   d="scan'208";a="459120058"
Date: Mon, 19 Oct 2009 17:52:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: ilkka.koskinen@nokia.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] twl4030: Do not dereference null pointer in error
 path
Message-ID: <20091019155230.GF3885@sortiz.org>
References: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
 <F80267346F10C541946CBE8909F1C39E12170A3880@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F80267346F10C541946CBE8909F1C39E12170A3880@NOK-EUMSG-02.mgdnok.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Fri, Oct 16, 2009 at 04:21:41PM +0200, ilkka.koskinen@nokia.com wrote:
> 
> Hi Samuel,
> 
> What is the status of this patch and the other one:
> [PATCH 2/2] twl4030: Enable low-power mode to 32KHz oscillator
I'm sorry but it seems I havent received those 2 patches. Could you please
re-send them ?

Cheers,
Samuel.


> Cheers, Ilkka
> 
> >-----Original Message-----
> >From: Koskinen Ilkka (Nokia-D/Tampere) 
> >Sent: 30 September, 2009 18:12
> >To: linux-kernel@vger.kernel.org; sameo@linux.intel.com
> >Cc: linux-omap@vger.kernel.org; Koskinen Ilkka (Nokia-D/Tampere)
> >Subject: [PATCH 1/2] twl4030: Do not dereference null pointer 
> >in error path
> >
> >Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> >---
> > drivers/mfd/twl4030-core.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> >index e424cf6..8cf0a02 100644
> >--- a/drivers/mfd/twl4030-core.c
> >+++ b/drivers/mfd/twl4030-core.c
> >@@ -792,7 +792,7 @@ twl4030_probe(struct i2c_client *client, 
> >const struct i2c_device_id *id)
> > 			twl->client = i2c_new_dummy(client->adapter,
> > 					twl->address);
> > 			if (!twl->client) {
> >-				dev_err(&twl->client->dev,
> >+				dev_err(&client->dev,
> > 					"can't attach client %d\n", i);
> > 				status = -ENOMEM;
> > 				goto fail;
> >-- 
> >1.6.0.4
> >
> >

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
