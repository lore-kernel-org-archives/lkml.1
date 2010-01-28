Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266Ab0A1QiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0A1QiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909Ab0A1QiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:38:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38002 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab0A1QiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=DrFssl+UELc8IU/Ua7nu+Jgkcki0s8EBZetuQm/49Yi7xpCZ8bz8fgtA9ScMliitF4
         2tiMZ7qQOTmsqMimobcHSVhcb4mF5qAUzCAZDO95/xV1vqayvCUTVdZWSW/TSpHgAHHV
         tzh5A7rmF1OqxoBbw1m2qUEnvC7hLcm9RrdrU=
Date: Thu, 28 Jan 2010 18:38:01 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] 2.6.33 vs. NVIDIA GForce GT 220
Message-ID: <20100128183801.2182c6f2@daedalus.pq.iki.fi>
In-Reply-To: <6a89f9d51001271828t54a28002k21ec96692af196b9@mail.gmail.com>
References: <20100112134335.GA21783@atrey.karlin.mff.cuni.cz>
	<20100123181817.GA2909@joi.lan>
	<201001231828.00557.koriakin@0x04.net>
	<20100126094740.GC10858@atrey.karlin.mff.cuni.cz>
	<6a89f9d51001271828t54a28002k21ec96692af196b9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 18:28:06 -0800
Stephane Marchesin <stephane.marchesin@gmail.com> wrote:

> On Tue, Jan 26, 2010 at 01:47, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > > I tried enabling staging nvidia driver on GT220, but
> >> > > apparently driver does not know about it. Unfortunately, I
> >> > > have one of those cards here.
> >> > >
> >> > > (I wonder... is there better mailing list? MAINTAINERS
> >> > > only lists linux-fbdev....)
> >>
> >> The list is nouveau@lists.freedesktop.org. And driver knows
> >> about GT220 just fine, I've been using it for a month or two
> >> on GT220 already. Don't bother
> >
> > Perhaps nouveau@lists.freedesktop.org should be added to
> > MAINTAINERS?
> >
> >> about the "supported cards" lists in xf86-video-nouveau or
> >> wherever else, the driver will happily bind to any nvidia
> >> video card with known generation, even if nobody has seen that
> >> precise model before.
> >
> > Unfortunately, the driver does not seem happy:
> >
> > Jan 18 12:56:38 pma kernel: [    0.491073] nvidiafb
> > 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > Jan 18 12:56:38 pma kernel: [    0.491507] nvidiafb: Device ID:
> > 10de0a20
> > Jan 18 12:56:38 pma kernel: [    0.491546] Chipset is 10de0a20
> > Jan 18 12:56:38 pma kernel: [    0.491584] nvidiafb: unknown
> > NV_ARCH Jan 18 12:56:38 pma kernel: [    0.492119] vga16fb:
> > initializing
> >
> 
> Hmm, but this is not nouveau, this is nvidiafb...

And both nvidiafb and vga16fb are known make Nouveau misbehave:
nvidiafb because it messes up the card state, and vga16fb because it
does not do the fb driver hand-over, AFAIK.

Relevant or not, I'd like to advertise our new troubleshooting page:
http://nouveau.freedesktop.org/wiki/TroubleShooting

I'm also adding the CCs that were dropped earlier.

Was the original question in this thread about nvidiafb or Nouveau?


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
