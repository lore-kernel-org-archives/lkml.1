Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYFLRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYFLRkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYFLRkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:40:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYFLRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:40:04 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806121035t40d3e8c4laccc768ae337075d@mail.gmail.com> (sfid-20080612_193551_838295_1C054FEF)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1213290205.3730.2.camel@johannes.berg>
	 <1ba2fa240806121035t40d3e8c4laccc768ae337075d@mail.gmail.com>
	 (sfid-20080612_193551_838295_1C054FEF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+uJ2PTNaCZvAlhzxVbuJ"
Date: Thu, 12 Jun 2008 19:39:00 +0200
Message-Id: <1213292340.3730.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+uJ2PTNaCZvAlhzxVbuJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yeah, but why bother if we can just allocate 10% of the size, waste a
> > lot less memory etc. mac80211 isn't going to pass in a scatter/gather
> > frame anyway.
>=20
> Hope never dies. I actually have seen this speed up the throughput so
> I will dig into it anyway.

Well, you can always add it back later if you make the networking stack
and mac80211 support it. It's a two-line patch after all.

> > The more interesting thing is the pci_alloc_consistent allocation right
> > below that is also _huge_, but that's because of the stupid hardware
> > design, or can the hardware cope with having the descriptors non-linear
> > in memory?
>=20
> We talk after your next HW design. How will configure 265 * 16
> descriptors separately.

Well, considering that other hardware does manage to do things
differently (say Broadcom because I know their DMA engine), I don't know
why your hw designers went wild with this. All you need is an
"end-of-frame" flag. But that's not really interesting to discuss,
unless this is actually controlled by the microcode and you can change
it.

johannes

--=-+uJ2PTNaCZvAlhzxVbuJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUV8wAAoJEKVg1VMiehFYaIEP/1eGs29PeSXMF+RTnOz0y/7G
aefYFoRSGhpa6SaaRuljlWoRXVrX8tGAE9XX8K8G/JBhFpyrg8n+ZjsWB0uIm/TH
spa4Wp6TJLo7i0uxHb0TXMCQXjK2q1EP37ZhwgiX+4yBQ+jp9R8m67iLqtRVRgSc
YbAUcNp1AVdm5PASNRPwAYsgrmRtNWRKinHNQwSCQjRGVJnGjPVR2hs4oRs/0Q/L
wt+nkIy5AzEiSxqXo+DK40EMJBQfXfHFSuvieZWVYeu7m39OW4/Edjhq6v7Vfq57
4YcqxRcLKWRaAsXBaoXAr5lXZHUNCsikrpqDR/KmactmvA6pDpM/7hLJbMgiZjef
AwUbEUy4T23h3bEznXFmdeseM2dJE87pMDOZOBzkCWfHUkjz0Fge+twXYFQtVpyY
9O3hMsEB3iRpvJ9tdkSjGec8mBCgf5bRNQ2DMBSrf8tUIESL9w1whw6DIBRal9Mu
ADsfeGfajMqq/qgaREwtwsNVpwGrLt9hImTPBwnhQAgbSBeSPS5gOgJIKbLJwUiA
9YCX7pHEW/+ufH4quU/HHaaCvVP4E1h+VENPN3yGqqhoomKDpqY4tU/1HnJIUi6Q
Rp8m89JJ9erOStH141TxZJzMz9O3HL8zE+q3sL+uZDTmBAmhGDplbhqFPV8202pH
VUWZRuIgrFJU8hsU4X9l
=X05g
-----END PGP SIGNATURE-----

--=-+uJ2PTNaCZvAlhzxVbuJ--

