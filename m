Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXGBLiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXGBLiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXGBLiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:38:07 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:43518 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbXGBLiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:38:06 -0400
Message-ID: <46881CAB.6050609@linuxtv.org>
Date: Sun, 01 Jul 2007 17:29:15 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [-mm patch] unexport dvb_pll_configure
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070701202403.GB10869@stusta.de>
In-Reply-To: <20070701202403.GB10869@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>   
>> ...
>> Changes since 2.6.22-rc4-mm2:
>> ...
>>  git-dvb.patch
>> ...
>>  git trees
>> ...
>>     
>
>
> Now that it's static, it should no longer be exported to modules...
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.22-rc6-mm1/drivers/media/dvb/frontends/dvb-pll.c.old	2007-07-01 21:42:17.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/media/dvb/frontends/dvb-pll.c	2007-07-01 21:42:25.000000000 +0200
> @@ -587,7 +587,6 @@
>  	// calculate the frequency we set it to
>  	return (div * desc->entries[i].stepsize) - desc->iffreq;
>  }
> -EXPORT_SYMBOL(dvb_pll_configure);
>  
>  static int dvb_pll_release(struct dvb_frontend *fe)
>  {
>
>   

Thanks, Adrian... I'm not sure how I missed that one ;-)

Acked-by: Michael Krufky <mkrufky@linuxtv.org>


Mauro,  I'll push this into hg and send you a pull request.

Cheers,
Mike
