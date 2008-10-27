Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ0LPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ0LPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJ0LPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:15:04 -0400
Received: from os.eurotux.com ([216.75.63.6]:41460 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYJ0LPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:15:01 -0400
Date: Mon, 27 Oct 2008 11:14:54 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
Message-ID: <20081027111454.GA3946@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	SCSI development list <linux-scsi@vger.kernel.org>
References: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org> <1224965493.3449.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <1224965493.3449.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 25, 2008 at 03:11:33PM -0500, James Bottomley wrote:
> On Sat, 2008-10-25 at 15:50 -0400, Alan Stern wrote:
> > On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> >=20
> > > [Adding CCs]
> > >=20
> > > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > >=20
> > > > Hello,
> > > >=20
> > > > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current=
]'.
> >=20
> > You can use usbmon to capture the details of what happens when you plug
> > in the drive.  Instructions are in the kernel source file
> > Documentation/usb/usbmon.txt.
>=20
> Try reversing this patch (apply with patch -p1 -R)
>=20
> James
>=20
> ---
>=20
> commit 10dab22664914505dcb804d9ad09cad6bc94d349
> Author: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
> Date:   Thu Sep 11 21:39:36 2008 -0400
>=20
>     [SCSI] sd: Fix handling of NO_SENSE check condition
>    =20
>     The current handling of NO_SENSE check condition is the same as
>     RECOVERED_ERROR, and assumes that in both cases, the I/O was fully
>     transferred.

<snip>

2.6.27.4 comes with it reverted. But I still get the same error.
Reapplied it as one more test, with the same error.

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkFoq0ACgkQinSul6a7oB+LBgCgkB7y4DMzg9UlVDKYU0ILtE7h
wV4An3Wd3/Yf9vB+yU2WNeyhx8NYP1vg
=Puoi
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
