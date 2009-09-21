Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZIVOLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZIVOLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZIVOLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:11:45 -0400
Received: from dan.rpsys.net ([93.97.175.187]:55954 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZIVOLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:11:44 -0400
Subject: Re: [PATCH] Adding LED1 & LED2 control for DA9034 backlight driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: =?UTF-8?Q?=E5=BA=84=E6=B5=A9=E5=9D=9A?= "(Haojian)" 
	<haojian.zhuang@gmail.com>,
       getarunks@gmail.com, linux-kernel@vger.kernel.org,
       eric.miao@marvell.com, mike@compulab.co.il
In-Reply-To: <f17812d70909180210xdceaf22u7901befa23cd89c7@mail.gmail.com>
References: <1253215662-11404-1-git-send-email-getarunks@gmail.com>
	 <f17812d70909180210xdceaf22u7901befa23cd89c7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 22:10:08 +0100
Message-Id: <1253567408.564.23.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 17:10 +0800, Eric Miao wrote:
> Could you please help check if the patch below applies for micco?

Eric/Haojian: Please let me know if you want me to take this patch or
not...

Cheers,

Richard

> On Fri, Sep 18, 2009 at 3:27 AM,  <getarunks@gmail.com> wrote:
> > From: Arun KS <getarunks@gmail.com>
> >
> > Signed-off-by: Arun KS <getarunks@gmail.com>
> > ---
> >  drivers/video/backlight/Kconfig     |    2 +-
> >  drivers/video/backlight/da903x_bl.c |   12 ++++++++++++
> >  2 files changed, 13 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> > index 90861cd..1607bc9 100644
> > --- a/drivers/video/backlight/Kconfig
> > +++ b/drivers/video/backlight/Kconfig
> > @@ -203,7 +203,7 @@ config BACKLIGHT_DA903X
> >        depends on BACKLIGHT_CLASS_DEVICE && PMIC_DA903X
> >        help
> >          If you have a LCD backlight connected to the WLED output of DA9030
> > -         or DA9034 WLED output, say Y here to enable this driver.
> > +         or DA9034 WLED, LED1, LED2 outputs, say Y here to enable this driver.
> >
> >  config BACKLIGHT_MBP_NVIDIA
> >        tristate "MacBook Pro Nvidia Backlight Driver"
> 

