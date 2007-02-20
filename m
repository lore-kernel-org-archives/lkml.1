Return-Path: <linux-kernel-owner+w=401wt.eu-S964954AbXBTOiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954AbXBTOiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964955AbXBTOiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:38:11 -0500
Received: from redstar.dorchain.net ([212.88.133.153]:43129 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954AbXBTOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:38:10 -0500
X-Greylist: delayed 1123 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 09:38:09 EST
Date: Tue, 20 Feb 2007 15:12:04 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Adrian Bunk <bunk@stusta.de>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, Hansjoerg Lipp <hjlipp@web.de>,
       Kai Germaschewski <kai.germaschewski@unh.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
Message-ID: <20070220141204.GI3250@Redstar.dorchain.net>
References: <45D74B46.3090602@imap.cc> <Pine.LNX.4.44.0702180017170.1150-100000@localhost.localdomain> <20070218104028.GU13958@stusta.de> <45DAFE0B.1070305@imap.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TBFeK8oU8Jij/i72"
Content-Disposition: inline
In-Reply-To: <45DAFE0B.1070305@imap.cc>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TBFeK8oU8Jij/i72
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2007 at 02:56:27PM +0100, Tilman Schmidt wrote:
> > One disadvantage of this approach is that in a kernel with=20
> > CONFIG_GIGASET_BASE=3Dy, you can't later compile and load the usb_gigas=
et=20
> > or ser_gigaset modules without rebooting since they require a change to=
=20
> > the kernel image.
>=20
> You've got a point there. So linking asyncdata.o into the modules that
> need it, as it is currently done, would perhaps be better after all?

=46rom the architectural point of view, what odds against making it a
module of its own? Dependancies are resolved by modprobe, so users should
be fine.
There are other library-like parts in the kernel where an object is
built statically when at least one needing driver is static, a module
when all nedding drivers are modules, or not at all but appears are a
config option when no in-kernel driver needs it.

>=20
> The alternative would be to always link asyncdata.o into the gigaset
> module whether it's needed or not. "size asyncdata.o" says:
>    text    data     bss     dec     hex filename
>    4200       0       0    4200    1068 asyncdata.o
> which appears tolerable.

Ugly. But I've seen worse.

Bye,

Joerg

--TBFeK8oU8Jij/i72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF2wG0jY4+4PdzvOARAgZOAJ9ypJoLSDyVNV+Olve6bOK+horqpgCfep1c
N2gmduQk9WNwRLf8Y86ezqk=
=T14C
-----END PGP SIGNATURE-----

--TBFeK8oU8Jij/i72--
