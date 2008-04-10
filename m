Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYDJLbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYDJLbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYDJLb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:31:26 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:57591 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYDJLb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:31:26 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc8=A0=3A_hibernation_sometimes_not_resuming?=
 =?iso-8859-15?q?_on_Dell_Latitude_D630?= (was: -rc7)
Date: Thu, 10 Apr 2008 13:30:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804031541.38493.didier@raboud.com> <200804031748.58113.rjw@sisk.pl>
In-Reply-To: <200804031748.58113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1252488.tZ0UWC8bAf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804101331.00089.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1252488.tZ0UWC8bAf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le jeudi, 3 avril 2008 17.48:57 Rafael J. Wysocki, vous avez =E9crit=A0:
> On Thursday, 3 of April 2008, Didier Raboud wrote:
> > Le mercredi, 2 avril 2008 14.06:29 Didier Raboud, vous avez =E9crit=A0:
> > > Le mardi, 1 avril 2008 23.22:35 Rafael J. Wysocki, vous avez =E9crit=
=A0:
> > > > On Tuesday, 1 of April 2008, Didier Raboud wrote:
> > > > > Le mardi, 1 avril 2008 23.11:15 Rafael J. Wysocki, vous avez =E9c=
rit=A0:
> > > > > > (...)
> > > > > > Can you please test the in-kernel hibernation, then?
> > > > > >
> > > > > > Rafael
> > > > >
> > > > > Hi,
> > > > >
> > > > > would like to. How=A0?
> > > > >
> > > > > # echo -n disk > /sys/power/state
> > > >
> > > > Yes, should work without the "-n", too.  Of course, you have to use
> > > > the 'resume=3D' kernel command line argument for this to work.
> > > >
> > > > Perhaps increase the console log level before that.
> > > >
> > > > Thanks,
> > > > Rafael
> > >
> > > Ok. I found a "better" way to do it=A0: just uninstall uswsusp and let
> > > kpowersave use hal to use suspend :-)
> > >
> > > Anyway, so far so good (with USB_SUSPEND not set), no hang. I will te=
st
> > > with USB_SUSPEND set and the incoming 2.6.25-rc8.
> > >
> > > Regards,
> > >
> > > Didier
> >
> > So far so good too with "stock" Debian Kernel (2.7.25-rc7-amd64) with
> > USB_SUSPEND set. No hang.
> >
> > The kernel suspend is less user-friendly than uswsusp though...
> >
> > So I bet there is a bug in uswsusp's kernel part ?
>
> It's almost the same as the in-kernel one, especially as far as the resume
> is concerned.  The simplest explanation coming to mind is that the image =
is
> somehow damaged in the uswsusp case.
>
> You can use the uswsusp's checksumming to verify that, though.
>
> Thanks,
> Rafael

Hi,=20

I upgraded my uswsusp to 0.8 and my kernel to 2.6.25-rc8 from Debian. I=20
activated the checksumming. I have hangs _again_ (I probably always had...).

Here's my /etc/uswsusp.conf=A0:
# --------
# /etc/uswsusp.conf(8) -- Configuration file for s2disk/s2both
resume device =3D /dev/mapper/Tamino-swap_1
compress =3D y
early writeout =3D y
image size =3D 967540654
shutdown method =3D platform
compute checksum =3D y
# --------

I don't know how I can help further... I will try without "early writeout".

Any help would be greatly appreciated=A0!

Best regards,=20

Didier

=2D-=20
Didier Raboud
Cornalles 2
1802 Corseaux
didier@raboud.com
079 480 67 82

--nextPart1252488.tZ0UWC8bAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH/fp0wW1nnOmiePARArCMAJ0WLf1hiwT2StSqf0OlHasej4merACdHvqr
qITCuH/i1EDAE3uDUbqm8+s=
=+S5U
-----END PGP SIGNATURE-----

--nextPart1252488.tZ0UWC8bAf--
