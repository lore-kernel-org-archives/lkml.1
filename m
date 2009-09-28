Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZI2AR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZI2AR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZI2ARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:17:55 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43691 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZI2ARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:17:54 -0400
X-Greylist: delayed 1288 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 20:17:54 EDT
Date: Tue, 29 Sep 2009 01:56:15 +0200
From: Florian Mickler <florian@mickler.org>
To: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] tty: fix vt_compat_ioctl
Message-ID: <20090929015615.022f1ef2@schatten>
In-Reply-To: <m2tyymho45.fsf@igel.home>
References: <m2y6nzgcud.fsf@igel.home>
	<20090928183337.GA10855@suse.de>
	<m2tyymho45.fsf@igel.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dlt20Bp+_Rg/a26UVLBHWFe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dlt20Bp+_Rg/a26UVLBHWFe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon, 28 Sep 2009 21:21:14 +0200
Andreas Schwab <schwab@linux-m68k.org> wrote:

> Greg KH <gregkh@suse.de> writes:
>=20
> > On Mon, Sep 28, 2009 at 08:10:02PM +0200, Andreas Schwab wrote:
> >> Call compat_unimap_ioctl, not do_unimap_ioctl.
> >
> > That's a nice description of what the patch does, but why do we need to
> > do that?
>=20
> It's a compat ioctl handler, so lets call the compat ioctl handler.
>=20
> Andreas.
>=20

Any other reasons? Why not rename the call then? That would be a
functional no-op with the same effect...=20


Sincerely,
Florian

p.s. maybe it is obvious if one looks at the code (i didnt), but it
should be described nonetheless in the commit-log!

--=20
A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing? =20
>> A: Top-posting. =20
>>> Q: What is the most annoying thing in e-mail?

--Sig_/dlt20Bp+_Rg/a26UVLBHWFe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrBTSQACgkQPjqCkyL3Kv1WvQCeP6dUss5oe+98+2vOlEcLhh+h
eecAnR64RJJ/OaCxz3kv16Ocr3wGJ86s
=Kdsi
-----END PGP SIGNATURE-----

--Sig_/dlt20Bp+_Rg/a26UVLBHWFe--
