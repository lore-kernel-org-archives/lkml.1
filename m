Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbXIAJNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbXIAJNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbXIAJNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:13:07 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:52061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXIAJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:12:44 -0400
Subject: Re: kernel-doc: fix doc blocks and html
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20070831210643.d5e2b5b1.randy.dunlap@oracle.com>
References: <20070831205845.0a935dc5.randy.dunlap@oracle.com>
	 <20070831210643.d5e2b5b1.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1olPC3nhXY2i4enb2LJw"
Date: Sat, 01 Sep 2007 11:14:02 +0200
Message-Id: <1188638042.7585.121.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1olPC3nhXY2i4enb2LJw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 21:06 -0700, Randy Dunlap wrote:

> Johannes is using a feature of kernel-doc that I wasn't even familiar
> with, also one that no one else is using.  I'm sure that Johannes can
> point us to some source code and generated output for it though.

It's not been merged yet:
http://johannes.sipsolutions.net/files/mac80211.h.txt
and just generated with your updated kernel-doc:
http://johannes.sipsolutions.net/files/mac80211.html

Example for the problem is in the "Hardware crypto acceleration"
section, but it's now obviously no longer visible.

> If you want to see a little of it in source code form, 2 net drivers
> use it, but then they aren't processed by kernel-doc for generated
> output.

Yeah, that's something I too need to work on. I'm thinking of making a
new include statement for the DOC: sections too, e.g.
   !P<filename>,<sectionname>

The thing is that if I simply add the docs to a docbook instead of DOC:
sections nobody will read it and I surely will continually need to point
to that. This way, people who use it daily will probably read it in the
header file but we can still generate pretty output for other places.

Anyhow, thanks a lot for this patch, the changes seem to work perfectly.

johannes

--=-1olPC3nhXY2i4enb2LJw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2S1a/ETPhpq3jKURAms1AKCz3miv0W1uldzvifHKEdTC9pDWMgCffPrw
7Ez3Aj6Oz8X4kXzyJGUrG2o=
=htTS
-----END PGP SIGNATURE-----

--=-1olPC3nhXY2i4enb2LJw--

