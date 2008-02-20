Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbYBTWsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbYBTWsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYBTWsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:48:02 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45577 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbYBTWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:48:00 -0500
X-Sasl-enc: XMZJYNmqPLNCBTNJn7N6i1os+baGzwJf/1zmlNYZ1Dbe 1203547678
Message-ID: <47BCAE1B.70407@imap.cc>
Date: Wed, 20 Feb 2008 23:47:55 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gregory Nietsky <gregory@networksentry.co.za>
CC: Andi Kleen <andi@firstfloor.org>, Tilman Schmidt <tilman@imap.cc>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN?
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BC5B5B.90308@firstfloor.org> <47BC79C9.8010102@networksentry.co.za>
In-Reply-To: <47BC79C9.8010102@networksentry.co.za>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB78A30D067AE65887BFF0D09"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB78A30D067AE65887BFF0D09
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.02.2008 20:04 schrieb Gregory Nietsky:
> did someone say interface/API documentation ooops ... <DUCK> seriously
> this is lacking and im sure as time goes on some volenteer (sucker) wil=
l
> get it up and running.this is not a show stoper but a nice to have.

It's an enabler for getting a move forward towards replacing the old
isdn4linux subsystem, which has really outlived its time by now.

> ill=20
> perhaps even help out a bit with things, i have some comments on useage=
=20
> and module parameters that could be usefull to the would be=20
> users.

Great. I'm looking forward to that.

> remember mISDN is just the kernel bits there is a user lib that=20
> takes care of userland bits.

But it's the kernel bits which are essential for porting existing
isdn4linux hardware drivers to CAPI/mISDN!

Btw, could you perhaps clear up the terminology while you're at it?
Last time I looked, mISDN was advertised as a framework for writing
CAPI drivers for passive ISDN adapters, in turn using CAPI4Linux,
the Linux CAPI subsystem. Nowadays the picture is rather less
clearcut.

>  >> b) still doesn't support all the hardware isdn4linux supports.
>  >
>  > That's a show stopper of course.
>=20
> of course not all hardware is supported and in some cases more hardware=
=20
> is supported ... there is a precident for this OSS/ALSA where the one i=
s=20
>   marked as DEPRICATED and the other promoted initialy as EXPERMENTAL .=
=2E.

I'm all for following that precedent: support both frameworks in
parallel, mark the old one as deprecated, give help in porting
hardware support to the new one, and when all the hardware that's
actually still in use in the field is supported by the new one,
remove the old one.

> after all if it were mainlined (in -mm even) the result would be better=
=20
> support and more choice there are far worse supported drivers than the =

> mISDN stack.

Absolutely. It's high time mISDN found it's way into the main tree,
otherwise it's in danger of degenerating into a niche solution.

> the reality is that isdn4linux is dead

Reality check, please. Have a look in the field how many systems
still use isdn4linux. Or do a simple experiment: Take a distribution
which has been known for good ISDN support in the past (I think you
know the one) and set it up for Internet access via a typical cheap
ISDN card. Then look which ISDN subsystem you end up with. You may
be surprised.

> idealy unsuported=20
> drivers need to be ported to mISDN or kept on life support.

Exactly. But there are two preconditions for porting an in-tree
isdn4linux driver to mISDN: First, mISDN must also be in-tree,
otherwise an in-tree driver cannot rely on it. And second, someone
must understand both the old driver and the mISDN framework in
order to be able to actually do the porting. The maintainer of the
old driver can provide the first part, but knowledge about mISDN
will need to come from the mISDN collective.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB78A30D067AE65887BFF0D09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvK4bMdB4Whm86/kRAqalAJ4hBV5JgJlZKgPpDdSPe1Ha+vxDXwCeJZpc
qECC0WvzNg2In1zrTNyqfcE=
=2q6L
-----END PGP SIGNATURE-----

--------------enigB78A30D067AE65887BFF0D09--
