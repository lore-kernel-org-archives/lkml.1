Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYF2CJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYF2CJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 22:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYF2CIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 22:08:52 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:40781 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbYF2CIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 22:08:51 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] add Sensoray 2255 v4l driver
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, dean@sensoray.com,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080628214335.40185450@gaivota>
References: <20080626231551.GA20012@kroah.com>
	 <20080628083154.33d3a93d@gaivota>
	 <1214690914.7722.10.camel@pc10.localdom.local>
	 <20080628214335.40185450@gaivota>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 04:05:30 +0200
Message-Id: <1214705130.2639.3.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Samstag, den 28.06.2008, 21:43 -0300 schrieb Mauro Carvalho Chehab:
> Hi Hermann,
> 
> On Sun, 29 Jun 2008 00:08:34 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> 
> > On an attempt to get recent drivers on a FC8 x86_64 machine to watch
> > Glastonbury music festival on BBC HD DVB-S with the saa714 driver on an
> > recently updated 2.6.25 FC kernel it also fails to compile on some
> > strlcpy attempt. Same with a 2.6.24 on the mail machine here.
> > 
> >   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/quickcam_messenger.o
> >   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c: In function 'vidioc_querycap':
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: error: implicit declaration of function 'dev_name'
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: warning: passing argument 2 of 'strlcpy' makes pointer from integer without a cast
> 
> The code is not backward compatible. It works only with 2.6.27-rc.
> 
> I'll add the macro ballow at compat.h to allow its out of tree compilation:
> 
> #define dev_name(dev)  ((dev)->bus_id)
> 
> This simple macro worked fine with 2.6.25.6.
> 
> Cheers,
> Mauro

Seems we had some crossed and delayed mails all over it.

I'll continue to cry, whenever it hurts.

Cheers,
Hermann


