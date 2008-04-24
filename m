Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYDXQkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYDXQkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYDXQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:40:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16549 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYDXQkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vdRma6nKW/mV/GrywL4X8B3VmHcP8ZjUII2eNaWD+Zs5G0rkqU+Ebx3BzD3cVyE5MQmadG9OX9M6G6RzBfWyCnbLA8RhFB4XwepsZo7q9Zm3j6YCxW2gfcwyPzswA9wkF6YL557sEF0negagthnvaDmwpxqELQdupJWFaqUZkqM=
Message-ID: <6101e8c40804240940p7960378ak4e563f3c24be06e8@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:40:02 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Gerhard Pircher" <gerhard_pircher@gmx.net>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>, airlied@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080409085435.232570@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <47E82D68.5070305@imap.cc>
	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
	 <47E83D14.8070800@imap.cc>
	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
	 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
	 <20080406143434.106940@gmx.net>
	 <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
	 <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
	 <20080409085435.232570@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/08, Gerhard Pircher <gerhard_pircher@gmx.net> wrote:
>
> -------- Original-Nachricht --------
> > Datum: Tue, 8 Apr 2008 23:01:26 +0200 (CEST)
> > Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > An: Dave Airlie <airlied@gmail.com>
> > CC: Gerhard Pircher <gerhard_pircher@gmx.net>,
> linux-kernel@vger.kernel.org
> > Betreff: Re: [2.6.25-rc6] possible regression: X server dying
>
> > On Tue, 8 Apr 2008, Dave Airlie wrote:
> >
> > > On Mon, Apr 7, 2008 at 12:34 AM, Gerhard Pircher
> > <gerhard_pircher@gmx.net> wrote:
> > > >
> > > >  Sorry for hijacking this thread, but I have a similar problem with
> > > >  the Xorg X server. I'm using kernel 2.6.25-rc8 on my AmigaOne
> > > >  (PowerPC) and the X server dies right on startup, but only if
> > > >  DRI/DRM is enabled. I tested this with both Xorg 7.1 (Debian Etch
> > > >  version) and Xorg 7.2 (Lenny). The X server was working fine with
> > > >  kernel 2.6.25-rc6. I have to mention that the AmigaOne uses uncached
> > > >  memory for DMA operations. Benjamin Herrenschmidt fixed DRI recently
> > > >  for non cache coherent systems and his patches are working fine (I
> > > >  applied them to kernel 2.6.25-rc6).
> > > >  Please take a look at the attached Xorg.0.log file or at the excerpt
> > > >  below:
> >
> > Hm, so looks like I'm not seeing some ghosts on mine either. 2.6.25-rc8
> > xorg runs under etch, but enters a tight (no syscalls) loop woth 100% CPU
> > load under lenny. A 2.6.24 based kernel works under both etch and
> > lenny...
> Strange! I guess I should recompile the kernel and test again. :(
> I also experienced a high load under Lenny, but IIRC this showed up under
> an older kernel (2.6.18), too (after X server is started, standard
> installation, no additional packages).

i have too this problem, the Xserver is dieing, but undependent from
kernel version, i think it is a xserver problem

Package: xserver-xorg-video-ati
Priority: optional
Section: x11
Installed-Size: 880
<>
Architecture: i386
Version: 1:6.6.3-2

under etch and 2.6.22.22 and 2.6.24.y kernel is ok
under lenny and 2.6.22.22 or 2.6.24.y or 2.6.25, in first start the
xserver crashed

>
> > Haven't had time to try to localize the problem. Glint xorg driver, DRM
> > and AGP are off, CONFIG_FB_PM2=y.
> The X server only dies on my machine, if DRM is on. I read somewhere that
> the lastest DRM patches need a newer Xorg version (~7.3). Could that be
> the problem with kernel 2.6.25-rc8?
>
> Thanks!
>
> Gerhard
> --
> Psssst! Schon vom neuen GMX MultiMessenger gehört?
> Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
