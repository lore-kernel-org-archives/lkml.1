Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYJ0TJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYJ0TJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYJ0TJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:09:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYJ0TJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:09:45 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Soeren Sonnenburg <kernel@nn7.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081027190631.GG22217@kernel.dk>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost>
	 <1225132278.3796.32.camel@johannes.berg>
	 <1225133082.3796.35.camel@johannes.berg>
	 <20081027190011.GA3951@localhost.aei.mpg.de>
	 <20081027190631.GG22217@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-63pwmylKpRDpSxJtRIdy"
Date: Mon, 27 Oct 2008 20:09:31 +0100
Message-Id: <1225134571.3796.41.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-63pwmylKpRDpSxJtRIdy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 20:06 +0100, Jens Axboe wrote:
> On Mon, Oct 27 2008, Carlos R. Mafra wrote:
> > On Mon 27.Oct'08 at 19:44:42 +0100, Johannes Berg wrote:
> > > On Mon, 2008-10-27 at 19:31 +0100, Johannes Berg wrote:
> > > > On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:
> > > >=20
> > > > > > Johannes, can you pls have a look?
> > > >=20
> > > > I did, and I have no idea. Makes no sense at all.
> > >=20
> > > The only thing I can remotely think of is that iwlwifi doesn't like
> > > being called back from within the call that it did to mac80211, which
> > > obviously happens here. But I have no idea, the code as it stands is
> > > correct, just the interaction with iwlwifi's resume seems to be broke=
n.
> > >=20
> > > Try this patch instead:
> >=20
> > Yep, with this patch it also works!
>=20
> Confirmed here as well, my x60 is happy again.

Thanks. Another alternative I could think of is deferring the
notifications to a work struct, but I'd rather see that in the driver I
think, not sure though, could be argued either way.

johannes

--=-63pwmylKpRDpSxJtRIdy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBhHoAAoJEKVg1VMiehFYjeAP/RMVTGHzKzCkkpps8mLEgnAe
SAxiCpNJkxqLRyJGvNvw2DqAx156N0uOrESYuPuY2ardcTMAeKWgVO1iGVJ6Xfcz
CDgAbTO4anVpXnJLBqPve/0FBW88YPajN4ebYt9Bm6QW0dDHpcIHNsrxLT/XLHQm
rPjFKUfyTC+BRnhcbRyWr2RsC5nLDPK5EDbigPEv0W+c0mAt6PuE15W/DtrSbBoa
WfyC9Gr1eAnLtR7OjwJHz/XUmAnMvqk/FOcYYqCp3J35VpBvj2zjKo47Pm1wHs7q
VoGevvLtZJy6NVTMVlweMr8WjdUaDIXduUU0z7w5+uT8XSwfd5p03oef2CKsScHr
e2hApv11DxoF57HUcpogGXTPhEgshkEhofKAzBkmc0C8xynuUApgKyHQUYvMoSAY
7pbo45aa7w2jwTj/bErDkDrqHglnxSYh7w/V1VUv1FsFPzD7QyZvvyH/fcM+Gf6n
mSNY7RGnHKezivqxsjHdHMFFJM7OVB86Rh3VixxU1P5yro5QNGJcg1vvh7mUI0OO
a5H8APFx8hEdRJxFgMWGcEl8SX5+cNP9rvnARIOJhkUGKLYcIccD96C6fS7yyENQ
+0T7xYhYUuJBiIi93iKhYJJvjEnfibwhXn+C5Af7SqvG5jwjuVmlxow3x0ugLFlK
1VSMAQgKNO2c1gx7br/8
=+9wD
-----END PGP SIGNATURE-----

--=-63pwmylKpRDpSxJtRIdy--

