Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXHVNWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXHVNWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbXHVNWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:22:04 -0400
Received: from iucha.net ([209.98.146.184]:49515 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbXHVNWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:22:03 -0400
Date: Wed, 22 Aug 2007 08:22:00 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       trond.myklebust@fys.uio.no
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070822132200.GO10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net> <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net> <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DheUW4aQn8WJk6WR"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--DheUW4aQn8WJk6WR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2007 at 03:42:26PM +0200, Jiri Kosina wrote:
> On Tue, 21 Aug 2007, Florin Iucha wrote:
>=20
> > There is another interesting angle to this: in the past, every time I=
=20
> > had keyboard problems, it used to be caused by the VFS and/or NFS...=20
> > after much wrangling, a bunch of bugs were fixed (Hi Trond, Peter,=20
> > Alan!). Now, after the keyboard "locked up", I used the mouse to close=
=20
> > the gnome session, then I logged-in remotely to reboot.  The reboot=20
> > process locked up and I need to use the reset button!  The second time=
=20
> > the keyboard "locked up" I listed my processes, and I noticed that I ha=
d=20
> > a couple of bash processes and a ssh process in "D" state. Something is=
=20
> > fishy again in the VFS ;)
>=20
> Yes, there were some NFS updates in between -rc2 and=20
> 28e8351ac22de25034e048c680014ad824323c65. I'd be now even more curious=20
> what are you going to find by bisect, please let us know.
>=20
> I added Trond to CC, full thread to be found at=20
> http://lkml.org/lkml/2007/8/21/151 for reference.
>=20
> Florin, it also might be useful to capture the states of stuck processess=
=20
> via alt-sysrq-T (or better by echo t > /proc/sysrq-trigger), so that we=
=20
> know better where are they stuck.

This morning it took a bit longer to hang, but it happened.  The
backtraces are at http://iucha.net/2.6.23-rc3/backtraces.gz .

I'll try a bisect session this weekend.

Cheers,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--DheUW4aQn8WJk6WR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGzDh4ND0rFCN2b1sRAk7JAJwNeaktDjx0pYeHHn+bgPFxU8uGVQCfYGoW
iXciDGe2QCNgfj9vftFCB/4=
=r9E8
-----END PGP SIGNATURE-----

--DheUW4aQn8WJk6WR--
