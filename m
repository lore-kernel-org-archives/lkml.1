Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYCHUzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYCHUzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYCHUz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:55:26 -0500
Received: from orac.ofobscurity.com ([208.65.234.197]:57914 "EHLO
	orac.ofobscurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYCHUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:55:26 -0500
From: Chris Knadle <Chris.Knadle@coredump.us>
Reply-To: Chris.Knadle@coredump.us
Organization: CoreDump.us
To: David Chinner <dgc@sgi.com>
Subject: Re: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
Date: Sat, 8 Mar 2008 15:55:08 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <200803062329.10486.Chris.Knadle@coredump.us> <20080307224645.GW155259@sgi.com>
In-Reply-To: <20080307224645.GW155259@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7416882.EpvflvuL6Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803081555.11695.Chris.Knadle@coredump.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7416882.EpvflvuL6Q
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 07 March 2008, David Chinner wrote:
> On Thu, Mar 06, 2008 at 11:29:07PM -0500, Chris Knadle wrote:
> > During the final unmount before reboot there was an assertion failure
> > from XFS=20
=2E..
> > When replying please CC me, as I am not currently subscribed to the lis=
t.
=2E..
> > Assertion failed: atomic_read(&mp->m_active_trans) =3D=3D 0, file:
> > fs/xfs/xfs_vfsops.c, line: 708

   Thank you for taking the time to look and reply to this.

> Known problem. Race in the VFS w.r.t. read-only remounts:
>
> http://marc.info/?l=3Dlinux-kernel&m=3D120106649923499&w=3D2

   At the bottom of the above message there's a patch which is not currentl=
y=20
merged in either the linux-2.6.24.y.git or linux-2.6.git trees.  That's=20
perhaps as it should be, but I would like to know if it's worth trying=20
merging the patch locally as an attempted workaround until such time as=20
2.6.25 is released and stable.

> The fix for the problem lies outside XFS:
>
> http://marc.info/?l=3Dlinux-kernel&m=3D120109304227035&w=3D2

   If I understand the above correctly, it sounds like the per-vfsmount is=
=20
going to be a new feature committed to 2.6.25, but probably not backported =
to=20
prior kernel trees.  If this feature was was added at 2.6.23.9 then if I=20
understand corectly it's only an issue between that version and 2.6.25; is=
=20
that correct?

   Thanks again.
   Cheers.

   -- Chris

=2D-=20

Chris Knadle
Chris.Knadle@coredump.us

--nextPart7416882.EpvflvuL6Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH0v0vXp5GJUAG6zwRAtjJAJ0e2VOyPT5sMon1i3YbsYcu8JmiwACfcYbT
iyw0uph23K23hMmPo3bjF6g=
=BwFt
-----END PGP SIGNATURE-----

--nextPart7416882.EpvflvuL6Q--
