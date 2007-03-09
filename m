Return-Path: <linux-kernel-owner+w=401wt.eu-S1767382AbXCIQiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767382AbXCIQiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767383AbXCIQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:38:09 -0500
Received: from lug-owl.de ([195.71.106.12]:55850 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767382AbXCIQiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:38:07 -0500
Date: Fri, 9 Mar 2007 17:38:05 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309163805.GV18564@lug-owl.de>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
References: <1173394873.3461.510.camel@pmac.infradead.org> <p737itqbdnl.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qa1NXTiqN6KSzHv0"
Content-Disposition: inline
In-Reply-To: <p737itqbdnl.fsf@bingen.suse.de>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qa1NXTiqN6KSzHv0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-09 17:11:10 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> > Most system calls seem to get added to i386 first. This patch
> > automatically generates a warning for any new system call which is
> > implemented on i386 but not the architecture currently being compiled.
> > On PowerPC at the moment, for example, it results in these warnings:
> > init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_rang=
e not implemented
> > init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not imp=
lemented
> > init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait no=
t implemented
>=20
> I think a better solution would be to finally switch to auto generated
> system call tables for newer system calls. The original reason why the
> architectures have different system call numbers -- compatibility with
> another "native" Unix -- is completely obsolete now. This leaves only
> minor differences of compat stub vs non compat stub and a few
> architecture specific calls.
>=20
> Of course the existing syscall numbers can't be changed, but for all new=
=20
> calls one could just add automatically for everybody.
>=20
> A global table with two entries (compat and non compat) and a per arch=20
> override table should be sufficient.

Not everybody has a simple indexed list of pointers :)  For example,
for vax-linux, we use a struct per syscall with the expected number of
on-stack longwords for the call.

So if something "new" is coming up, please keep in mind that it should
be flexible enough to represent that. :)

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:         "really soon now":      an unspecified period of time=
, likly to
the second  :                                 be greater than any reasonabl=
e definition
                                              of "soon".

--qa1NXTiqN6KSzHv0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF8Y1tHb1edYOZ4bsRAtTbAJ9pGP5OP+CAJDhS2ToKtazUmhEdAACfWTh8
7TLIUGzDrO/z2z3buGDL3uI=
=R054
-----END PGP SIGNATURE-----

--qa1NXTiqN6KSzHv0--
