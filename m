Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXJ3LzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXJ3LzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXJ3LzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:55:06 -0400
Received: from iucha.net ([209.98.146.184]:46549 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXJ3LzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:55:05 -0400
Date: Tue, 30 Oct 2007 06:55:04 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071030115504.GM25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mI5TpPl/qDRoXxBg"
Content-Disposition: inline
In-Reply-To: <E1ImpbK-0000l3-1u@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--mI5TpPl/qDRoXxBg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2007 at 07:49:41PM +0800, Fengguang Wu wrote:
> On Tue, Oct 30, 2007 at 06:42:50AM -0500, Florin Iucha wrote:
> > On Tue, Oct 30, 2007 at 03:54:03PM +0800, Fengguang Wu wrote:
> > > It could be triggered by the more aggressive writeback behavior - the
> > > new code will keep on retrying as long as there are dirty inodes pend=
ing.
> > >=20
> > > Florin, would you try the attached patches against 2.6.24-git?
> > > They may generate big traffic of printk messages, but will help
> > > debug the problem.
> >=20
> > I have updated to v2.6.24-rc1-334-g82798a1.  After using my computer
> > for two hours, I left the computer idle overnight.  This morning,
> > pdflushd is again consuming 25% of a CPU.  I will try Fengguang's
> > patches today.
>=20
> Thank you.
>=20
> Be sure to stop klogd ;-)
> A `dmesg` will be sufficient for debugging.
>=20
> btw, I cannot reproduce it with simple NFSv3 tests.

This is using nfsv4.  And being idle in a GNOME session with home
mounted from the server is hardly a stressful experience.  But what do
I know ;)

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--mI5TpPl/qDRoXxBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJxuYND0rFCN2b1sRAsAHAKCoBRaszdsixwkNlN6h6e5ZumhLdACgoAIF
ymxE2K6cVSN3UcjHqJvTIiY=
=WEt4
-----END PGP SIGNATURE-----

--mI5TpPl/qDRoXxBg--
