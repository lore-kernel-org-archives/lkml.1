Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZCGWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZCGWDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZCGWDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:03:06 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:56575 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbZCGWDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:03:05 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sat, 7 Mar 2009 23:02:45 +0100
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903042020.57671.eike-kernel@sf-tec.de> <200903072205.48658.rjw@sisk.pl>
In-Reply-To: <200903072205.48658.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1557545.GmaeG49JIz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903072302.54450.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1557545.GmaeG49JIz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Rafael J. Wysocki wrote:
> On Wednesday 04 March 2009, Rolf Eike Beer wrote:
> > Hi,
> >
> > I tested several snapshots post 2.6.28 and all of them show one severe
> > problem: resume from disk is not always successful. Only about 50% of t=
he
> > resume attempts work, in the other cases I just get a completely black
> > screen, can't switch to text console or anything. What I often get is a
> > line like this in the logs directly before suspend:
> >
> > [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for
> > disabled pipe 0
> >
> > Afterwards I find nothing in the logs. Switching back to 2.6.28 and
> > everything works fine again. I have a Toshiba A110-178 running openSuSE
> > 11.1 32 bit with KDE 4.2.0. I upgraded my Xserver from 1.5 to 1.6
> > yesterday but that did not change anything. The only external module I
> > use is the omnibook module (http://sf.net/projects/omnibook) which I've
> > been using for years without any problems.
> >
> > VGA device is this:
> >
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
> > 943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00
> > [VGA controller])
> >         Subsystem: Toshiba America Info Systems Device ff01
> >         Flags: bus master, fast devsel, latency 0, IRQ 16
> >         Memory at dc100000 (32-bit, non-prefetchable) [size=3D512K]
> >         I/O ports at 1800 [size=3D8]
> >         Memory at c0000000 (32-bit, prefetchable) [size=3D256M]
> >         Memory at dc200000 (32-bit, non-prefetchable) [size=3D256K]
> >         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
> > Count=3D1/1 Enable-
> >         Capabilities: [d0] Power Management version 2
> >         Kernel modules: intelfb
> >
> > 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
> > 943/940GML Express Integrated Graphics Controller (rev 03)
> >         Subsystem: Toshiba America Info Systems Device ff01
> >         Flags: bus master, fast devsel, latency 0
> >         Memory at dc180000 (32-bit, non-prefetchable) [size=3D512K]
> >         Capabilities: [d0] Power Management version 2
> >
> > If you have any patches you want to try me or have any further questions
> > just mail me. If you're hanging around at CeBIT I can come over and we
> > can discuss this in person as I'm there for the next days anyway.
>
> What version of the Intel X driver are you using?

(II) Module intel: vendor=3D"X.Org Foundation"
        compiled for 1.6.0, module version =3D 2.6.2
        Module class: X.Org Video Driver
        ABI class: X.Org Video Driver, version 5.0

This is was I have currently, before it was whatever was shipped with openS=
uSE=20
11.1.

Eike

--nextPart1557545.GmaeG49JIz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmy7w4ACgkQXKSJPmm5/E7C8wCglDpL6UDOFEZtMBaBMEgTFeww
fjsAoKMuOWzxa404V1alu7ZThLlrKGFL
=VlCN
-----END PGP SIGNATURE-----

--nextPart1557545.GmaeG49JIz--
