Return-Path: <linux-kernel-owner+w=401wt.eu-S1763817AbYA1XMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763817AbYA1XMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763369AbYA1XIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:08:39 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:63292 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763991AbYA1XIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:08:35 -0500
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 18:08:35 EST
Date: Mon, 28 Jan 2008 17:38:17 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb/frontends/xc5000.c: make a
 struct static
In-reply-to: <20080128221030.GP8767@does.not.exist>
To: Adrian Bunk <bunk@kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@hauppauge.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Message-id: <479E5959.1010601@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20080128221030.GP8767@does.not.exist>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> struct XC5000_Standard[] can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Reviewed-by: Steven Toth <stoth@hauppauge.com>

Thanks Adrian.

Mauro, please merge.

- Steve

> 
> ---
> e1f9c8304c807ecce026156ee2185925295fe835 
> diff --git a/drivers/media/dvb/frontends/xc5000.c b/drivers/media/dvb/frontends/xc5000.c
> index f642ca2..a5094b7 100644
> --- a/drivers/media/dvb/frontends/xc5000.c
> +++ b/drivers/media/dvb/frontends/xc5000.c
> @@ -151,7 +151,7 @@ typedef struct {
>  #define FM_Radio_INPUT2 	21
>  #define FM_Radio_INPUT1 	22
>  
> -XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
> +static XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
>  	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
>  	{"M/N-NTSC/PAL-A2",   0x0600, 0x8020},
>  	{"M/N-NTSC/PAL-EIAJ", 0x0440, 0x8020},
> 
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer

