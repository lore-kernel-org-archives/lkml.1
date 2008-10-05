Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYJEQAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYJEQAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYJEQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:00:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:41278 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754014AbYJEQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:00:24 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/JQD8t7e3J2JQQUQOoitbNeGTNAiI7NpQEhw263l
	3Skt89jOHsKIQ0
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to 2.6.26-stable tree
Date: Sun, 5 Oct 2008 18:00:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20081001234424.C72C114543E5@imap.suse.de> <200810041827.04721.s.L-H@gmx.de> <20081005025401.GA22549@suse.de>
In-Reply-To: <20081005025401.GA22549@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1829258.WFviQgPjpj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810051800.21970.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1829258.WFviQgPjpj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Sonntag, 5. Oktober 2008, Greg KH wrote:
> On Sat, Oct 04, 2008 at 06:27:03PM +0200, Stefan Lippers-Hollmann wrote:
> > Hi
> >=20
> > On Donnerstag, 2. Oktober 2008, gregkh@suse.de wrote:
> > >=20
> > > This is a note to let you know that we have just queued up the patch =
titled
> > >=20
> > >     Subject: sata_nv: disable hardreset for generic
> > >=20
> > > to the 2.6.26-stable tree.  Its filename is
> > >=20
> > >     sata_nv-disable-hardreset-for-generic.patch
> > >=20
> > > A git repo of this tree can be found at=20
> > >     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-que=
ue.git;a=3Dsummary
> > >=20
> > >=20
> > > From 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 Mon Sep 17 00:00:00 2001
> > > From: Tejun Heo <tj@kernel.org>
> > > Date: Fri, 29 Aug 2008 16:13:12 +0200
> > > Subject: sata_nv: disable hardreset for generic
> > >=20
> > > From: Tejun Heo <tj@kernel.org>
> > >=20
> > > commit 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 upstream
> > >=20
> > > of them being unifying probing, hotplug and EH reset paths uniform.
> > > Previously, broken hardreset could go unnoticed as it wasn't used
> > > during probing but when something goes wrong or after hotplug the
> > > problem will surface and bite hard.
> > >=20
> > > OSDL bug 11195 reports that sata_nv generic flavor falls into this
> > > category.  Hardreset itself succeeds but PHY stays offline after
> > > hardreset.  I tried longer debounce timing but the result was the
> > > same.
> > >=20
> > >   http://bugzilla.kernel.org/show_bug.cgi?id=3D11195
> > >=20
> > > So, it seems we'll have to drop hardreset from the generic flavor.
> > >=20
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Peer Chen <pchen@nvidia.com>
> > > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >=20
> > On 2.6.26.5 + the pending stable queue applied, this patch results in l=
ots=20
> > of noise in my syslog (full gzipped dmesg with and without this patch=20
> > attached):
>=20
> This patch has been removed from the stable queue, so it shouldn't be an
> issue anymore, right?

Yes, you're right. I missed it being removed from queue-2.6.26 a few hours=
=20
before I actually sent the mail, sorry for the noise.

Thanks
	Stefan Lippers-Hollmann

--nextPart1829258.WFviQgPjpj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjo5JUACgkQORbEMfgJlPbs2ACdFUaTKaupu97ZO4F4bjDB2BzF
OucAnjyNOaQzoALvcvIQeZWY4iAfrnbs
=PxFV
-----END PGP SIGNATURE-----

--nextPart1829258.WFviQgPjpj--
