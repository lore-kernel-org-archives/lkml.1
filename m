Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234Ab0ANQYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0ANQYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986Ab0ANQYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:24:32 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:45009 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab0ANQYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:24:32 -0500
Date: Thu, 14 Jan 2010 14:22:31 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, ibm-acpi@hmh.eng.br,
       Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alsa: use subsys_initcall for sound core instead of
 module_init
Message-ID: <20100114162230.GB1396@holoscopio.com>
References: <1263334840-6118-1-git-send-email-cascardo@holoscopio.com>
 <s5h63765wm0.wl%tiwai@suse.de>
 <20100114155342.GA1396@holoscopio.com>
 <s5hd41ck6ct.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <s5hd41ck6ct.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2010 at 05:18:26PM +0100, Takashi Iwai wrote:
> At Thu, 14 Jan 2010 13:53:43 -0200,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > On Wed, Jan 13, 2010 at 07:48:07AM +0100, Takashi Iwai wrote:
> > > At Tue, 12 Jan 2010 20:20:39 -0200,
> > > Thadeu Lima de Souza Cascardo wrote:
> > > >=20
> > > > This is needed for built-in drivers which are built before the soun=
d directory,
> > > > like thinkpad_acpi.
> > > >=20
> > > > Otherwise, registering a card fails.
> > >=20
> > > Oh well, this kind of problem hits again.
> > >=20
> > > I don't remember why subsys_init() wasn't taken before...  Maybe some
> > > dependency between sound and V4L or so.  But, it's worth to check aga=
in.
> > >=20
> >=20
> > Any references to this dependency problem, so I can try to help and inv=
estigate
> > about it and do some tests?
>=20
> I also don't remember.  That was a long long ago... :)
>=20
> > > I'll apply this after some testing.
> > >=20
> >=20
> > Built-in thinkpad-acpi started working for me after these changes. I ca=
n't tell
> > you about any subsystem that stopped working, like some V4L driver.
>=20
> Did you test whether the sound subsystem still works as modules?
>=20

It does. I've just reapplied those patches on top of rc4, and I'm currently
running it with CONFIG_SOUND=3Dm, and my sound card works nicely, thanks.

>=20
> Takashi

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktPRMYACgkQyTpryRcqtS1W3gCfYh0RT7J1iJvT5Drtzi+kXdmc
vFMAn1cvygZe7MQV7IsaI+hPZPRPy0Nx
=5LlF
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
