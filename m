Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXBTQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXBTQPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965350AbXBTQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:15:39 -0500
Received: from kirby.webscope.com ([204.141.84.54]:48349 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965347AbXBTQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:15:38 -0500
Message-ID: <45DB1E18.8070009@linuxtv.org>
Date: Tue, 20 Feb 2007 11:13:12 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [-mm patch] make dvb_usb_gl861_debug static
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070220000729.GV13958@stusta.de>
In-Reply-To: <20070220000729.GV13958@stusta.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>> ...
>> Changes since 2.6.20-rc6-mm3:
>> ...
>>  git-dvb.patch
>> ...
>>  git trees.
>> ...
> 
> This patch makes the needlessly global dvb_usb_gl861_debug static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Michael Krufky <mkrufky@linuxtv.org>

> 
> ---
> --- linux-2.6.20-mm1/drivers/media/dvb/dvb-usb/gl861.c.old	2007-02-17 17:49:03.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/media/dvb/dvb-usb/gl861.c	2007-02-17 17:49:20.000000000 +0100
> @@ -12,7 +12,7 @@
>  #include "qt1010.h"
>  
>  /* debug */
> -int dvb_usb_gl861_debug;
> +static int dvb_usb_gl861_debug;
>  module_param_named(debug,dvb_usb_gl861_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
>  
> 
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer


-- 
Michael Krufky

