Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYJ0Qm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYJ0Qm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYJ0Qlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:41:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYJ0Qls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:41:48 -0400
Subject: Re: bisected: 2.6.28-rc broke my iwl4965 wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081027163812.GB6377@tesla> (sfid-20081027_173820_318230_ACAD18C7)
References: <20081025222208.1d2a2c8b@infradead.org>
	 <20081027163812.GB6377@tesla> (sfid-20081027_173820_318230_ACAD18C7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8HvvIqjmKeRLps5zwWdp"
Date: Mon, 27 Oct 2008 17:41:34 +0100
Message-Id: <1225125694.3796.28.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8HvvIqjmKeRLps5zwWdp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 09:38 -0700, Luis R. Rodriguez wrote:

> > 2.6.28-rc1 broke my (intel 4965) wireless, and I've bisected it down to
> > the commit below..... something's fishy with this...

> Additionally if the old behaviour is desired for now (until distributions
> catch up and add CRDA) CONFIG_WIRELESS_OLD_REGULATORY can be enabled
> and you'll get the old behaviour of defaulting to country "US".

Luis, Arjan's bug is actually indicative of a driver bug, he told me
that he actually runs into driver message like "cannot set TX power
while scanning", and it's fixed by setting WIRELESS_OLD_REGULATORY for
some reason. Arjan, do you still have the actual messages you get when
it fails? That's a separate bug we should address, rather than relying
on it not happening with the old regulatory setting.

johannes

--=-8HvvIqjmKeRLps5zwWdp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBe87AAoJEKVg1VMiehFY2AsQAIEMsK0HKHWQ3k1aRyETRkJV
OiGqANDU9i0nCGO7Y4TWZqJzUJtu1/vEdbfwhW6ZXPdsT2WKwrmHVsAX0PnpZH+Q
OZDVRF/eePx0e+gpUiJVnmg/KHfRtd5cYiXt1tOQZejvSYAU3pRc7Yp0GGub/HoY
gG0q7Q6HarW+zNCrPqQNDxa/Ug0hlaXc3EAl8SD/CWe0li5V35ZkDnay1QR+Z35K
EPVCKDvMUV2+w4lI9cvSZ2+epbWeYqQ1xgxiv9GP8KIzJT1LqDRS0yeuMHVNq01S
t7BaTfaVPp83mUkWqaSXdgJ6i6r4OQb6ZmpcLdATmqXP+EMSRCq3YcdJThMuWqyy
6xUoyGx3dQyJw+gGJxs17gbARILMGMX8lhNPUBuN+hhl07n0I+M4W4H0IXbF/PTL
syIceJhzOL5Qh5kvngLEM/yEGEgDj5VfFzKb+AR5uFbiHCwWx3KYvZ5csVsZWSzm
b5DA/RGGUNeV8owa6g9/1Aa5GNMT3yarFNe4GxxVpiY/di36tSwv8EWG3BFlxjLU
TTbjChnwkBhgFxKRAA5Pk5g60Kyqznukfn4NDMBkLAy15goBGt/8uCI/f85HrgdL
BOrH8oBgDFFTxtXzEhGc2bDWk9Ue3y/cUuRZxh6odCYTCklXaihc7n6rDs5gJGlh
hadv/GfPgJp+l/k+i601
=VlGa
-----END PGP SIGNATURE-----

--=-8HvvIqjmKeRLps5zwWdp--

