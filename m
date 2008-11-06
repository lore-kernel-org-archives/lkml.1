Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbYKFU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbYKFU1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYKFU1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:27:40 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50017 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKFU1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:27:39 -0500
Date: Thu, 6 Nov 2008 14:27:36 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: Re: [PATCH 0/5] eCryptfs: Filename Encryption
Message-ID: <20081106202736.GC6688@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081105155754.GA1759@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20081105155754.GA1759@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2008 at 04:57:54PM +0100, Pavel Machek wrote:
> On Tue 2008-11-04 15:37:54, Michael Halcrow wrote:
> > This patchset implements filename encryption via a
> > passphrase-derived mount-wide Filename Encryption Key (FNEK)
> > specified as a mount parameter. Each encrypted filename has a
> > fixed prefix indicating that eCryptfs should try to decrypt the
> > filename. When eCryptfs encounters
>=20
> That is 'interesting'. What happens if normal filename has that
> prefix?

If the lower filename has the prefix but does not have a valid tag 70
packet following the prefix, then eCryptfs will complain in the syslog
and then pass through the lower filename as-is.

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQEcBAEBAwAGBQJJE1M4AAoJENtAhTFtyodplYUH/3o+htJSyFZqd4Mqen3vmLXs
+ESgoZ6/lEcj7QT7o/2PFjt15tWDOvDDW7Fv0pSuLKcEkwg0P/gt+vfqVsV5GCui
sbVt4pb17ngM6IkJ+7hNBwtoxtx7nMMXBO2an2zuRpydA+GTRZ6YAXn+fU5S5URZ
mRIUTircI/qGknM7zvwNFCQ0F7VqZl9qT//0MfnZ34XUzvdgHClJPXfIppVV7Ztc
JHLGiQAZd56xu4J/wIPO8EoJfRf35GXXEvxW6scRVMsYO1DJdF40qXEC3BUHJd/A
km1Dt+0J1j92Y6PsePi20rKc2f7TKULNhC3nY+TTWGqceSWpadtz3BHhU5jv2WU=
=8fDo
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
