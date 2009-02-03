Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZBCM5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZBCM5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZBCM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:57:22 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:49899 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZBCM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:57:22 -0500
Date: Tue, 3 Feb 2009 10:57:45 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Ben Finney <ben+debian@benfinney.id.au>
Cc: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090203125744.GC3788@vespa.holoscopio.com>
Mail-Followup-To: Ben Finney <ben+debian@benfinney.id.au>,
	debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <87ljsnzo4v.fsf@benfinney.id.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 03, 2009 at 11:44:00PM +1100, Ben Finney wrote:
> "Daniel P. Berrange" <berrange@redhat.com> writes:
>=20
> > On Mon, Feb 02, 2009 at 07:41:53PM -0200, Thadeu Lima de Souza Cascardo=
 wrote:
> > > So, we have some more options now: /cgroups, /containers,
> > > /dev/cpuset, /dev/cpuctl, /opt/cgroup, /opt/cpuset.
> >=20
> > Putting new mount points in / is not really acceptable, so that rules
> > out the first two. /opt is just totally wrong, since that is intended
> > for add on software packages. /dev/ feels a little odd, since it is
> > not really device nodes
>=20
> I agree with all that Thadeu Lima says here. I would add that cgroups
> are nothing to do with device nodes, so definitely don't belong in
> =E2=80=98/dev/=E2=80=99 either.

The message you quoted is from Daniel Berrange, not me. Could you also
tell your rationale for not agreeing with /?

Regards,
Cascardo.

> Since they're a filesystem mapping =E2=80=9Cfor browsing and manipulation
> from user space=E2=80=9D of a kernel facility, I think =E2=80=98/sys/cgro=
ups/=E2=80=99 is
> appropriate.
>=20
> --=20
>  \     =E2=80=9CIt's my belief we developed language because of our deep =
inner |
>   `\                  need to complain.=E2=80=9D =E2=80=94Jane Wagner, vi=
a Lily Tomlin |
> _o__)                                                                  |
> Ben Finney

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmIP0gACgkQyTpryRcqtS0gfwCeNESvcsbtrnHDydfihDHfsyXV
1F0AnjoRLwCaSYBnpRh9BIJFhQn2EJMd
=w/XP
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
