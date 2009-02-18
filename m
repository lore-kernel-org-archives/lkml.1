Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZBRQXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZBRQXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZBRQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:23:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:1981 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZBRQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:23:03 -0500
Date: Wed, 18 Feb 2009 18:26:47 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND] binfmt_script: rewrite using
	parse_shell_args()
Message-ID: <20090218162647.GC5270@epbyminw8406h.minsk.epam.com>
References: <1234970162-10694-1-git-send-email-kirill@shutemov.name> <1234970162-10694-2-git-send-email-kirill@shutemov.name> <20090218151616.GC15195@srcf.ucam.org> <20090218152252.GB5270@epbyminw8406h.minsk.epam.com> <20090218152956.GA15633@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <20090218152956.GA15633@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2009 at 03:29:56PM +0000, Matthew Garrett wrote:
> On Wed, Feb 18, 2009 at 05:22:52PM +0200, Kirill A. Shutemov wrote:
> > On Wed, Feb 18, 2009 at 03:16:16PM +0000, Matthew Garrett wrote:
> > > On Wed, Feb 18, 2009 at 05:16:01PM +0200, Kirill A. Shutemov wrote:
> > > > parse_shell_args() allows to use more than one argument in shebang.
> > >=20
> > > As mentioned before, this breaks userspace ABI.
> >=20
> > Do you have real world example of breakage?
>=20
> Have you checked every script on every Linux system?

Ok, I've looked into other kernels(*BSD and OpenSolaris). None of them
parse arguments in shebang. Before 6.x FreeBSD parsed arguments, but then
they changed behaviour.

So, this patch is wrong. What about patch #3?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.org/

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmcNscACgkQbWYnhzC5v6pmVwCghFkFlLWFnOzwaPx/Bs5hf3iC
9Y4An2gSX4OO1vv9r/kjwRSur7JcTr/1
=uKxq
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
