Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZHZG1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZHZG1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbZHZG1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:27:05 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:60618 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZHZG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:27:02 -0400
X-Greylist: delayed 28380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 02:27:01 EDT
Subject: Re: Linux 2.6.31-rc7
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
In-Reply-To: <21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
	 <4A941E8B.8080902@plzk.org>
	 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
	 <4A94599F.9020508@plzk.org>
	 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
	 <1251239637.26348.20.camel@gaiman.anholt.net>
	 <20090826015127.GA1402@zhen-devel.sh.intel.com>
	 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
	 <21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3slU+zjExgDFNerIw+Ks"
Date: Tue, 25 Aug 2009 23:26:58 -0700
Message-Id: <1251268018.18434.16.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3slU+zjExgDFNerIw+Ks
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 13:47 +1000, Dave Airlie wrote:
> On Wed, Aug 26, 2009 at 1:33 PM, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> >
> >
> > On Wed, 26 Aug 2009, Zhenyu Wang wrote:
> >>
> >> > In my experience, the BIOS setup doesn't reflect what outputs should=
 be
> >> > used at runtime, and certainly not the correct configuration of the
> >> > enabled outputs.  For example, if we went to this, the giant monitor
> >> > attached to my laptop that I actually look at would go unused.
> >>
> >> yeah, normally VBIOS startup just needs or only can driver one pipe, s=
o
> >> we don't have any pre knowledge except detect everything.
> >
> > Umm. What's your guys point, exactly?
> >
> > The fact is, as-is, YOU DETECT THE WRONG OUTPUTS!
> >
> > If you actually detected things _right_, none of this would be an issue=
.
> > But you don't. And you seem to have a really hard time even admitting
> > that. You try to re-detect things, and you SCREW UP.
>=20
> This isn't anything to do with redetection, and in the Mac case there isn=
't
> even a BIOS table that you can really rely on since Apple hard coded all
> this stuff into their EFI and Mac OSX drivers.
>=20
> Now you probably get a video bios using Apples bios layer, but it also
> is most likely not telling anything close to the truth about the hw layou=
t.
>=20
> Just because the BIOS manages to light up an output in now way effects
> whether the driver can do the same.
>=20
> >
> >> we already have some mac relate bugs open, but please report on it so =
we
> >> do have people with hardware to try and response. We have recently got=
 a
> >> MacBook, yakui is looking after the modesetting issue on it.
> >
> > Quite frankly, I've reported these things several times. I've been open=
 to
> > try patches. Nothing has ever come out of it.
> >
> > I have a Mac Mini that I reported as broken over a month ago. I have a
> > Westemere I've reported as not doing any DDC probing - and that I have =
to
> > disable the LVDS probing on entirely in order to not make KMS set up th=
e
> > display to go to a non-existent LVDS port.
> >
> > You claim that you "detect everything", but quite frankly, you don't. T=
he
> > KMS code seems to assume that if it's a mobile chipset, it should have =
an
> > LVDS output - and whether anything is connected to that or not is total=
ly
> > immaterial. There's clearly _zero_ "detection" going on.
> >
> > And the thing is, X seems to get it right, at least more often than KMS
> > does.
> >
>=20
> I'm not sure why the mac-mini hack hasn't been merged I asked for it a
> few times,
> I'd rather the proper solution was merged but that seems to not have
> happened either.

Your complaint about needing to do the proper solution was why I never
merged it.  It looked like a NAK to me.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-3slU+zjExgDFNerIw+Ks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqU1bIACgkQHUdvYGzw6vdQcwCePOOpZRFU+hiv6EBCFB/kjqO/
noEAn0H0CkTKu9r5WUjsDihaI+q+vbLR
=l06e
-----END PGP SIGNATURE-----

--=-3slU+zjExgDFNerIw+Ks--
