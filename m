Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXIADCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXIADCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 23:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXIADCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 23:02:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57365 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXIADCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 23:02:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] Patch pvr2 driver to allow development of maple bus driver
Date: Fri, 31 Aug 2007 23:02:45 -0400
User-Agent: KMail/1.9.7
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
References: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com> <8bd0f97a0708311312n78f1c163o20aa17214bfe3702@mail.gmail.com> <8b67d60708311314p39c7be30v630e97189d656abf@mail.gmail.com>
In-Reply-To: <8b67d60708311314p39c7be30v630e97189d656abf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2842700.tRFiO0C76J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708312302.46542.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2842700.tRFiO0C76J
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 August 2007, Adrian McMenamin wrote:
> On 31/08/2007, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > On 8/31/07, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> > > This patch makes the PVR2 VBLANK interrupt on the SEGA Dreamcast
> > > shareable - a small but necessary change to enable ongoing efforts to
> > > develop a driver for the maple bus on the Dreamcast. (Maple is Sega's
> > > proprietary serial interface for the Dreamcast and can be set to
> > > synchronise dma transfers to the VBLANK).
> > >
> > > This has no impact on the performance of the PVR2.
> >
> > sharable implies the interrupt handler checks to see if it actually
> > caused the interrupt ... which it doesnt at the moment ... presumably,
> > you're making it shared because another device will be using that
> > interrupt as well ... so when that other device gets an interrupt, how
> > do you know it's for that device and not PVR2 ?
>
> If the interrupt occurs then it will be for both of them. The hardware
> cannot be removed and the maple bus driver is set for hardware sync.
>
> The question seems redundant to me.

i really dont know how the maple bus works or what piece of hardware is wir=
ed=20
up to the same interrupt line.  my point is that if the other device fires =
an=20
interrupt, the pvr interrupt handler may be executed and attempt to do work=
=20
when in reality the pvr was not the source of the interrupt.
=2Dmike

--nextPart2842700.tRFiO0C76J
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iQIVAwUARtjWVkFjO5/oN/WBAQIEihAAwyLXm7hCbKiuCpwU7iNYURfWp925lzni
q1iVZvZ2wHwTTlGfdwdcj5JqNq+jNLo4FYhKaHNj3MSOfMCPbsj0M0Ehv/OIkar3
lahqKE0U+W89OATfdMTxSpSUdn+gSv/8Kk8QipOYW6wB2zfy7xDHCYVN4K62WqFp
EThjI5t04drP064RdJfyV1m1BM95OS33+QHpeGBtFsjp2yRdKFcfkblYvk15rD6V
hszT4h0sqz70Q8xfcqdXYYrTUJpOMr0Cw9pb4EO8nwpKDlpA0F1EWcDpMwDgJILF
X234btTxtPf5hZ0HFfvXUvvO4cpoFRnYvErGGObirxQqSPgmADQ2rqXhw5KqxQ8K
megksKI4DuehAeLXEFDP9YGX23hBBPSrFV4TL4Qj+A5QcsN18LNaK26eOBlHAss3
yg/HwbpL2fb8CNu0K0HvOOez4R2Egxwy2GeUYzPageyaQalODlfvKz56lpOeSy/v
dMepbhuAWxm4GM6YQoP/9hItqFQv/vSZdmZv24iEzAm2qwUY1x2OUx68esRdKGbn
+F+zAV5HYFHLj3HHe2zvOFlr+7ocdPypRlnqmSW+xXoWWTMW43jesQUYP3Fwlhmx
LtkCgM+xFUclRWWzq5r8Vzo4WRcCUUYIkdGtyARf1kRQ5NLHUk1oU/kFJUaXUNRw
MRamIjVzobA=
=80Nh
-----END PGP SIGNATURE-----

--nextPart2842700.tRFiO0C76J--
