Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZF3CVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZF3CVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF3CVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:21:47 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:34201 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZF3CVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:21:47 -0400
Date: Mon, 29 Jun 2009 22:21:50 -0400
From: Stephen Frost <sfrost@snowman.net>
To: dann frazier <dannf@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630022150.GY20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com> <20090630015140.GV20436@tamriel.snowman.net> <20090630015302.GN22480@ldl.fc.hp.com> <20090630021013.GX20436@tamriel.snowman.net> <20090630021517.GA3683@lackof.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m3zcgECJg5Qgddwj"
Content-Disposition: inline
In-Reply-To: <20090630021517.GA3683@lackof.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 22:15:57 up 18 days, 23:42, 21 users,  load average: 0.05, 0.05,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m3zcgECJg5Qgddwj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* dann frazier (dannf@hp.com) wrote:
> On Mon, Jun 29, 2009 at 10:10:13PM -0400, Stephen Frost wrote:
> > On the other hand, my coworker tells me that he tried swapping in a P800
> > on this DL585 and it didn't solve the problem at the time.  Specifics
> > are a bit difficult (this was last year sometime).
>=20
> Ok - though my question was to understand what is different between
> this DL585 and the other DL585s you have that are working.

Well, I've got 4 DL585 G2's:

durin - running 2.6.22 w/ P800 fine (had problems w/ 2.6.26)
stormcrow - running 2.6.22 w/ P800 fine (had problems w/ 2.6.26)
aragorn - running 2.6.29 w/ P800 fine
vardamir - running 2.6.30 w/ P600 (needs noacpi to boot)

vardamir used to have a QLogic Fibrechannel card in it as well, but I
pulled that over the weekend to see if that was causing the problem.
Didn't change anything though.

I don't think there's anything else all that special about these
systems.  aragorn's got 64G, the other 3 have 16G, I think they've all
got a full complement of SAS drives, etc.

Do you want me to pull dmesg/lspci/etc/etc from all these systems?
Would it help?  What would you like to see, specifically?

	Thanks,

		Stephen

--m3zcgECJg5Qgddwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJdr4ACgkQrzgMPqB3kijr2ACeI3M8OclkL2sb+wX8D5mRoNNG
i2cAoJZUeyjICNvZrMd4925gC3XZsISX
=Rh31
-----END PGP SIGNATURE-----

--m3zcgECJg5Qgddwj--
