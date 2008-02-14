Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbYBNPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbYBNPKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbYBNPK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:10:26 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:14367 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbYBNPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O8o18ZrUqFSzQ5DBwbDXX4vmeP4hymCWA13jjFsfmGIPf/s/NLeSP5w8G3AwAV0Wd/aHJKWM3tg3va4kmhyqrJoBcywMqWk/0sTszjcsu5ns7H6B3GFDO76Zr92v2yQfSjHejhIx3Tazd5vxrfuiLur7bwCOo8eFb1oPAp/d85k=
Message-ID: <bc64b4640802140710n697ce2f4l23832bba073169c8@mail.gmail.com>
Date: Thu, 14 Feb 2008 18:10:19 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Cc: "Dmitry Torokhov" <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Liam Girdwood" <liam.girdwood@wolfsonmicro.com>,
       "Graeme Gregory" <gg@opensource.wolfsonmicro.com>,
       "Mike Arthur" <mike.arthur@wolfsonmicro.com>,
       "Stanley Cai" <stanley.cai@intel.com>,
       "Rodolfo Giometti" <giometti@enneenne.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Pete MacKay" <linux01@architechnical.net>,
       "Marc Kleine-Budde" <mkl@pengutronix.de>, "Ian Molton" <spyro@f2s.com>,
       "Vincent Sanders" <vince@kyllikki.org>,
       "Andrew Zabolotny" <zap@homelink.ru>
In-Reply-To: <1202912042-2631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213140648.GD31617@rakim.wolfsonmicro.main>
	 <1202912042-2631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/2/13, Mark Brown <broonie@opensource.wolfsonmicro.com>:
>  diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
>  new file mode 100644
>  index 0000000..f0d9fc0
>  --- /dev/null
>  +++ b/include/linux/wm97xx.h
>  @@ -0,0 +1,308 @@

...

>  +#define WM97XX_POLL            0x8000  /* initiate a polling measurement */
>  +#define WM97XX_ADCSEL_X                0x1000  /* x coord measurement */
>  +#define WM97XX_ADCSEL_Y                0x2000  /* y coord measurement */
>  +#define WM97XX_ADCSEL_PRES     0x3000  /* pressure measurement */

shouldn't this be 0x4000 ?

>  +#define WM97XX_ADCSEL_MASK     0x7000
>  +#define WM97XX_COO             0x0800  /* enable coordinate mode */
>  +#define WM97XX_CTC             0x0400  /* enable continuous mode */

-- 
With best wishes
Dmitry
