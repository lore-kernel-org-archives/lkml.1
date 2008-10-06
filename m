Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYJFH1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYJFH1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 03:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYJFH1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 03:27:34 -0400
Received: from server.drzeus.cx ([85.8.24.28]:59296 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262AbYJFH1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:27:33 -0400
Date: Mon, 6 Oct 2008 09:27:22 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081006092722.414a7200@mjolnir.drzeus.cx>
In-Reply-To: <20081006063035.GA19244@elte.hu>
References: <20081001083532.GE31009@elte.hu>
	<1222851025-30619-1-git-send-email-steven@uplinklabs.net>
	<20081005142819.GB12047@cs181140183.pp.htv.fi>
	<f488382f0810051553t32a24972ma7baa92605f43772@mail.gmail.com>
	<20081005231607.GB10747@cs181140183.pp.htv.fi>
	<f488382f0810051648k14b499ecj9d625c55b38ed2f0@mail.gmail.com>
	<20081006063035.GA19244@elte.hu>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-29149-1223278050-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-29149-1223278050-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Oct 2008 08:30:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:

>=20
> Correct. Would you be interested in sending a patch for a (default-off)=20
> debug feature that allows the disabling of all the gcc annotations? That=
=20
> way we can do regular sweeps to determine whether old annotations are=20
> still relevant on latest and greatest GCC.
>=20

How would you find the ones that are no longer needed though?

Perhaps we could make it so that uninitialized_var() itself emits a
warning. That way you could turn that option on and check that you
always have pairs of warnings.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-29149-1223278050-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjpvd4ACgkQ7b8eESbyJLinOACfbF/Ose58XflH2n8iW/NA2lYB
XAcAnRkjkCSkrWlSoXcufe4m1PLIwjhw
=Dswt
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-29149-1223278050-0001-2--
