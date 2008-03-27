Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYC0Iqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYC0Iqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYC0Iql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:46:41 -0400
Received: from atlas.linux2go.dk ([88.198.22.52]:59665 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYC0Iqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:46:40 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 04:46:40 EDT
Date: Thu, 27 Mar 2008 09:38:36 +0100
From: Soren Hansen <soren@ubuntu.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] don't suspend/resume 8xx chips
Message-ID: <20080327083835.GF30926@butch.linux2go.dk>
References: <200803261628.12336.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <200803261628.12336.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2008 at 04:28:12PM -0700, Jesse Barnes wrote:
> Recent testing has turned up some bugs in the new Intel suspend/resume co=
de=20
> for old, 8xx chipsets.  So for 2.6.25 it probably makes sense to apply th=
is=20
> patch, which should prevent the new code from getting called on those=20
> chipsets.  We should have this fixed soon, but not in time for 2.6.25=20
> unfortunately.  Note that this patch (along with the suspend/resume code =
in=20
> general) could use more testing.

I've tested this patch on two different laptops: A Uniwill 223 and an
IBM Thinkpad X40. Both have Intel 855 graphics. The former now suspends
and hibernates just fine (it fails without the patch). The latter works
both with and without the patch.

--=20
Soren Hansen               |=20
Virtualisation specialist  | Ubuntu Server Team
Canonical Ltd.             | http://www.ubuntu.com/

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH610LonjfXui9pOMRAoabAKCzCr7k3BwvrmSywM2A36zLgvyOEQCfTIIU
0BpZ2K/5Ve3p+TTwCKkV4/0=
=Bsd/
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
