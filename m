Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZHBBCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZHBBCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 21:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZHBBCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 21:02:23 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:57085 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbZHBBCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 21:02:22 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 5DC311B3647
Subject: Re: USB devices supporting raw or sliced VBI for closed captioning?
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steve Castellotti <sc@eyemagnet.com>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0907311845r259b129em3bd89b7915718cd5@mail.gmail.com>
References: <1249082438.18313.30.camel@odyssey.sc.user.nz.vpn>
	 <d9def9db0907311845r259b129em3bd89b7915718cd5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 02:49:19 +0200
Message-Id: <1249174159.3255.13.camel@pc07.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Samstag, den 01.08.2009, 03:45 +0200 schrieb Markus Rechberger:
> Hi,
> 
> On Sat, Aug 1, 2009 at 1:20 AM, Steve Castellotti<sc@eyemagnet.com> wrote:
> >
> >        I was wondering if anyone could please point me at a list or similar
> > resource for USB capture devices which support raw (or sliced) VBI
> > access for producing a closed caption transcript through software such
> > as zbvi-ntsc-cc or ccextractor? Specifically I'm wanting a device
> > capable of S-Video, Composite, or even Component input, not just ATSC,
> > as most USB devices seem focused around these days.
> >
> >        I've managed to get this working with various ivtv and saa713x based
> > PCI devices, but aren't aware of any USB implementations of chipsets
> > which use those drivers.
> >
> >
> >        Searching online, I found this archived message:
> >
> > http://lists.zerezo.com/video4linux/msg16402.html
> >
> > which states:
> >
> >> some em2840 and newer devices are able to capture raw vbi in
> >> linux (sliced vbi isn't possible yet)
> >> em2820, em2800, em2750 do not support vbi at all.
> >
> >
> >        Checking the em28xx driver homepage for recent models, I found this
> > entry:
> >
> > http://mcentral.de/wiki/index.php5/Em2880
> >
> >> officially the em2880 is em2840 + DVB_T
> >
> >
> >        which implies that not only is the "em2880" series a "newer" device,
> > but it should in fact already contain the "em2840" chip specifically
> > mentioned.
> >
> >
> >        Later on that same page, in the list of devices:
> >
> > ATI/AMD TV Wonder 600
> >
> >
> >        and on the manufacturer's page:
> >
> > http://ati.amd.com/products/tvwonder600/usb/index.html
> >
> >
> >        Under the list of "Input Connectors":
> >
> >> S-video input with adapter
> >
> >
> >
> >        Picking up one of these devices, I attempted to tune into the S-Video
> > feed and check the /dev/vbi0 device, but received the same error message
> > as I do with all other em28xx devices encountered thus far:
> >
> >> Cannot capture vbi data with v4l interface:
> >> /dev/vbi0 (AMD ATI TV Wonder HD 600) is not a raw vbi device.
> >
> >
> >
> >        Can anyone please point me in the right direction?
> >
> >        I would much prefer to be certain the next purchase is supported.
> >
> >
> >
> > Thanks!
> >
> 
> we do support Raw VBI for our devices, Sundtek MediaTV Pro for closed
> captioning.
> Alternatively we also have full support for ATSC-analogTV USB devices
> for the US market ([em288x]-[AVFB4910]-[Trident drx-J]-[tda18271]) the
> european product which we are selling is also capable of decoding NTSC
> closed caption.
> 
> http://sundtek.de/shop/Digital-TV-Sticks-oxid/Sundtek-MediaTV-Pro.html
> (this is just the information about the
> European/DVB-T/DVB-C/analogTV(raw VBI) device, we do not have the
> US/ATSC/analogTV(rawVBI) product listed there, although we do offer it
> to business customers) We support it from Linux 2.6.15 on.
> 
> Best Regards,
> Markus Rechberger

Hi,

anything new about how to deal with commercial advertising on lists,
depending totally on our source?

Please have a look.

Cheers,
Hermann




