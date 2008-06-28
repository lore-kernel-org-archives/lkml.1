Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbYF1WMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbYF1WMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYF1WLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:11:50 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:46105 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYF1WLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:11:48 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] add Sensoray 2255 v4l driver
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, dean@sensoray.com,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080628083154.33d3a93d@gaivota>
References: <20080626231551.GA20012@kroah.com>
	 <20080628083154.33d3a93d@gaivota>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 00:08:34 +0200
Message-Id: <1214690914.7722.10.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Samstag, den 28.06.2008, 08:31 -0300 schrieb Mauro Carvalho Chehab:
> On Thu, 26 Jun 2008 16:15:51 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > From: Dean Anderson <dean@sensoray.com>
> > 
> > This driver adds support for the Sensoray 2255 devices.
> > 
> > It was primarily developed by Dean Anderson with only a little bit of
> > guidance and cleanup by Greg.
> > 
> 
> Hmm... there are still a few minor CodingStyle errors:
> 
> ERROR: return is not a function, parentheses are not required
> #881: FILE: drivers/media/video/s2255drv.c:792:
> +       return (dev->resources[fh->channel]);
> 
> WARNING: line over 80 characters
> #898: FILE: drivers/media/video/s2255drv.c:809:
> +       strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
> 
> ERROR: return is not a function, parentheses are not required
> #932: FILE: drivers/media/video/s2255drv.c:843:
> +       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1053: FILE: drivers/media/video/s2255drv.c:964:
> +               return (ret);
> 
> ERROR: return is not a function, parentheses are not required
> #1428: FILE: drivers/media/video/s2255drv.c:1339:
> +       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1452: FILE: drivers/media/video/s2255drv.c:1363:
> +                       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1467: FILE: drivers/media/video/s2255drv.c:1378:
> +                       return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #1487: FILE: drivers/media/video/s2255drv.c:1398:
> +                               return (-ERANGE);
> 
> total: 7 errors, 1 warnings, 2508 lines checked
> 
> I'm applying the patch right now on my tree.
> 
> Dean,
> 
> When you have some time, please send me a patch fixing those.
> 
> heers,
> Mauro
> 

On an attempt to get recent drivers on a FC8 x86_64 machine to watch
Glastonbury music festival on BBC HD DVB-S with the saa714 driver on an
recently updated 2.6.25 FC kernel it also fails to compile on some
strlcpy attempt. Same with a 2.6.24 on the mail machine here.

  CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/quickcam_messenger.o
  CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c: In function 'vidioc_querycap':
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: error: implicit declaration of function 'dev_name'
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: warning: passing argument 2 of 'strlcpy' makes pointer from integer without a cast
make[3]: *** [/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o] Error 1
make[2]: *** [_module_/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.24.7-92.fc8-i686'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l'
make: *** [all] Fehler 2

Cheers,
Hermann



