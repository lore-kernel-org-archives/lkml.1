Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbXG2Phh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbXG2Phh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbXG2Ph3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:37:29 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:56161 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761116AbXG2Ph2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:37:28 -0400
Message-ID: <46ACB434.2040007@linuxtv.org>
Date: Sun, 29 Jul 2007 11:37:24 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] make struct dvb_pll_fcv1236d
 static
References: <20070729145705.GK16817@stusta.de>
In-Reply-To: <20070729145705.GK16817@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
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
> struct dvb_pll_fcv1236d can become static.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.23-rc1-mm1/drivers/media/dvb/frontends/dvb-pll.c.old	2007-07-26 09:04:23.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/media/dvb/frontends/dvb-pll.c	2007-07-26 09:04:32.000000000 +0200
> @@ -501,7 +501,7 @@
>  
>  /* Philips FCV1236D
>   */
> -struct dvb_pll_desc dvb_pll_fcv1236d = {
> +static struct dvb_pll_desc dvb_pll_fcv1236d = {
>  /* Bit_0: RF Input select
>   * Bit_1: 0=digital, 1=analog
>   */
>   
Oops.  I created that patch before the "dvb: remove static dependencies
on dvb-pll" patch was applied, but the fcv1236d patch didn't get merged
until after the fact.  Thanks for the fix, Adrian.  I'll apply this.

Regards,

Mike Krufky
