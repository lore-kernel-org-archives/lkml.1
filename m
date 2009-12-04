Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZLDQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZLDQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZLDQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:03:08 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:49493 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbZLDQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:03:07 -0500
Date: Fri, 4 Dec 2009 17:03:11 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] block: io_context refcount fixes
Message-ID: <20091204160311.GK2430@hawkmoon.kerlabs.com>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org
References: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com> <20091204153443.GH8742@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-29084-1259942531-0001-2"
Content-Disposition: inline
In-Reply-To: <20091204153443.GH8742@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-29084-1259942531-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04/12/09 16:34 +0100, Jens Axboe wrote:
> On Fri, Dec 04 2009, Louis Rilling wrote:
> >=20
> > Hi,
> >=20
> > When reading copy_io() I found probable refcounting issues with shared
> > io_context. IIUC, the following two patches could fix those issues.
> > If I am correct, then those fixes should go to stable too.
> >=20
> > Based on v2.6.32 and compile-tested only.
>=20
> Thanks, those both look correct. I will apply them, but please also do
> whatever testing that caused you to find this in the first place (or was
> it code inspection)?

Yes this was code inspection. I have no testcase for CLONE_IO.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-29084-1259942531-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksZMr8ACgkQVKcRuvQ9Q1QYKwCglGk2qgKZE4hCTP9JC2uZPRVh
5TwAoKCeQ57nPDr4oavejFLX0yuJrQo3
=mwkR
-----END PGP SIGNATURE-----

--=_bohort-29084-1259942531-0001-2--
