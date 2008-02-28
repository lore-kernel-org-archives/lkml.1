Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbYB1XNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbYB1XNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYB1XNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:13:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:37490 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753401AbYB1XNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:13:02 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/tK9pjC3Xt92pKK6QjenEQuX27lDPXK2bqDxpBMA
	OfCLy58NXxqqHA
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Fri, 29 Feb 2008 00:12:55 +0100
User-Agent: KMail/1.9.7
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802282303.42676.mb@bu3sch.de> <f19298770802281448k91e71dh6583db94e1a6f4e7@mail.gmail.com>
In-Reply-To: <f19298770802281448k91e71dh6583db94e1a6f4e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1319594.1LmDY20t65";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802290012.56654.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1319594.1LmDY20t65
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 28. Februar 2008, Alexey Zaytsev wrote:
> On Fri, Feb 29, 2008 at 1:03 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 26 February 2008 23:41:55 Michael Buesch wrote:
> >  > On Tuesday 26 February 2008 23:12:32 Alexey Zaytsev wrote:
> >  > > >  Yeah, seems so. But if you are willing to test an adjusted vers=
ion, I can
> >  > > >  probably do a backported version of this patch.
> >  > > >  This patch is well tested and does the right thing, so I'm will=
ing to sign
> >  > > >  off a backported version of this.
> >  > > >  First need to find the place in the old phy.c code that matches=
 the new wa.c code.
> >  > > >
> >  > > I'll do the testing.
> >  >
[...]
> >
> >  So are you actually going to do this anytime soon?
> >
>=20
> Sorry for the delay. Yes, it worked fine.
>=20
> Btw, when booting the system with the b43 driver, I get a
> ~30 socond delay after the boot scripts report
> "Waiting for /dev to be fully populated" and all the modules
> get loaded. Is this something expected?

That is most likely udev related, which doesn't really like module names=20
and default interface names changing for a known MAC address, depending on=
=20
your distribution (the following example assumes debian sid, udev 0.114-2)=
=20
you might have something like /etc/udev/rules.d/z25_persistent-net.rules=20
(which lists MAC addresses and the associated persistent interface name),=20
removing the corresponding stanza for your Broadcom wireless card (or=20
removing the whole file alltogether and letting udev (or rather=20
z45_persistent-net-generator.rules) recreate it during the next boot will=20
most likely fix it.=20

This issue is in no way b43 related, it happens with "every" networking=20
devices with changing module names (at least for every legacy wireless=20
module being replaced by a new mac80211 based driver).

Regards
	Stefan Lippers-Hollmann

--nextPart1319594.1LmDY20t65
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHxz/4ORbEMfgJlPYRAiMjAJ9geJFkjktTEQ2Sen3n/tg7SgdQQACeJD+w
6/HHBWgAywHESJx3Dqas3XQ=
=vdzK
-----END PGP SIGNATURE-----

--nextPart1319594.1LmDY20t65--
