Return-Path: <linux-kernel-owner+w=401wt.eu-S932426AbZJAIgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbZJAIgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbZJAIgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:36:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54177 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbZJAIgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:36:37 -0400
Subject: Re: [PATCH v2] twl4030: Fix boot with twl4030 usb transceiver
 enabled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roger Quadros <ext-roger.quadros@nokia.com>
Cc: sameo@linux.intel.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
In-Reply-To: <1254385536-26912-1-git-send-email-ext-roger.quadros@nokia.com>
References: <1254385536-26912-1-git-send-email-ext-roger.quadros@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 11:36:29 +0300
Message-Id: <1254386189.32310.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Oct 2009 08:36:31.0170 (UTC) FILETIME=[469A4220:01CA4272]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 11:25 +0300, Roger Quadros wrote:
>  	if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
>  		child = add_child(3, "twl4030_bci",
> @@ -532,16 +531,61 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  	}
>  
>  	if (twl_has_usb() && pdata->usb) {
> +
Why is this extra line?

> +		static struct regulator_consumer_supply usb1v5 = {
> +			.supply =	"usb1v5",
> +		};

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

