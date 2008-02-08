Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYBHXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYBHXI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYBHXIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:08:18 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:60055 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbYBHXIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:08:16 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 00:08:05 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802082000.39919.prakash@punnoor.de> <20080208210258.GA13058@one.firstfloor.org>
In-Reply-To: <20080208210258.GA13058@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4455695.cxD9fTYe8d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802090008.05430.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4455695.cxD9fTYe8d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 08 February 2008 Andi Kleen hast written:
> On Fri, Feb 08, 2008 at 08:00:39PM +0100, Prakash Punnoor wrote:
> > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> > > >
> > > > Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
> > >
> > > Confirmed what? Did you test my patch on both machines?
> > > What was the result?
> >
> > I confirmed that it (nforce2) needed the acpi_skip_timer_override. If y=
ou
> > read my mail, you knew I didn't test your patch.
>
> Ok can you please do so then?  Or stop your obstructism?

Grr, I don't know why I am discussing with stubborn and/or arrogant devs li=
ke=20
you seem to be. But I actually did what you wanted and as *expected* - as I=
=20
said I understand that trivial piece of code you posted - your patch fails=
=20
here for my nforce2:

cat /proc/interrupts
           CPU0
  0:        832    XT-PIC-XT        timer <---------------- seeing this?
  1:         10   IO-APIC-edge      i8042
  8:          2   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:         84   IO-APIC-edge      i8042
 14:         38   IO-APIC-edge      ide0
 16:     184026   IO-APIC-fasteoi   eth0
 17:          0   IO-APIC-fasteoi   Technisat/B2C2 FlexCop II/IIb/III Digit=
al=20
TV PCI Driver
 18:          0   IO-APIC-fasteoi   NVidia nForce2
 19:      12460   IO-APIC-fasteoi   nvidia
NMI:          0   Non-maskable interrupts
LOC:      74695   Local timer interrupts
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0


And no, I won't test it on my MCP51 as I *know* what happens: As soon as I=
=20
disable hpet, the quirk gets triggered and will lock up my system.

Now stop wasting my time and do your homework!

> Your objections don't make sense, so you can NAK all day.  You're
> talking about timer overrides in PIC mode which is just pure non sense.

Then talk to Len Brown, maybe he is able to make you understand.

> Ok if you're unwilling to test I'm ignoring you in the future.
> Please stop sending me email.

Actually I don't care anymore. The last time you also didn't really cared f=
or=20
what I said about your way of quirking the nforce boards.

I know how to make the kernel behave in this matter, it is just a pity for=
=20
other users, who don't know...

Good luck!
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart4455695.cxD9fTYe8d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrODVxU2n/+9+t5gRAksxAJ9gA3NnUzUUKWlRsYkqRY5VB8fxhQCeOOkA
Bb6pVkwcU/EKVmi6k2Luu4E=
=4aUc
-----END PGP SIGNATURE-----

--nextPart4455695.cxD9fTYe8d--
