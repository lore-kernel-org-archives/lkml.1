Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbZGJAGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbZGJAGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZGJAGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:06:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35017 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZGJAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:06:43 -0400
Date: Fri, 10 Jul 2009 10:06:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-Id: <20090710100625.13e75cfd.sfr@canb.auug.org.au>
In-Reply-To: <20090709231956.GA1033@kroah.com>
References: <20090709130430.090863dd.sfr@canb.auug.org.au>
	<20090709231956.GA1033@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jul_2009_10_06_25_+1000_agu_OIbxFMjCwFo3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jul_2009_10_06_25_+1000_agu_OIbxFMjCwFo3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 9 Jul 2009 16:19:56 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jul 09, 2009 at 01:04:30PM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the ttydev tree got conflicts in
> > drivers/usb/serial/generic.c and include/linux/usb/serial.h between com=
mit
> > d8298d029cdd5d944c3d8369d2862de94d12ae4b ("USB: serial: regression fix =
to
> > move sysrq from hot path") from the usb.current tree and commit
> > cf8456fe1aaed1776bf4c26c18adef76e472b9fa ("tty-usb-fix-perf-regression")
> > from the ttydev tree.  Also between commit
> > a2170a444ef9a89a7ec9acc72d79e5db433effc4 ("USB: serial: optimize sysrq
> > function calls") from the usb.current tree and commit
> > bfce6b042a47c9cdd55c7cd231e58710ec1fa4e1 ("tty-usb-fix-kref-leak") from
> > the ttydev tree.
> >=20
> > The first two commits above seem to be trying to do the same thing (or
> > similar) so I have used the ttydev version for now.
> >=20
> > I fixed them up (see below) and can carry the fixes as necessary.
>=20
> Thanks for the fix, I don't know what happened in the tty tree, I've not
> touched the USB tree for a week or so now...

In case you missed it, Alan has submitted the above two ttydev patches to
Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Jul_2009_10_06_25_+1000_agu_OIbxFMjCwFo3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpWhgEACgkQjjKRsyhoI8wCcACdEpdzxRhWDhwkjk6bbfvxsaTN
Qi4AoIMLhh9g6TGEnJm0P4uXx//g7ZdQ
=ZyGH
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jul_2009_10_06_25_+1000_agu_OIbxFMjCwFo3--
