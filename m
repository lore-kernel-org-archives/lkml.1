Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbYFQTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbYFQTca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYFQTcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:32:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbYFQTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:32:22 -0400
Subject: Re: Oops report for the week preceding June 16th, 2008
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, linville@tuxdriver.com,
       davej@redhat.com
In-Reply-To: <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
References: <4856AFDF.5080901@linux.intel.com>
	 <20080617092023.GA20621@elte.hu>
	 <20080617.022652.76635616.davem@davemloft.net>
	 <20080617153356.GA3510@elte.hu> <20080617175414.GA9866@suse.de>
	 <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ljb/B3v9GVdNBrKoUu7m"
Date: Tue, 17 Jun 2008 21:31:36 +0200
Message-Id: <1213731096.3803.127.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ljb/B3v9GVdNBrKoUu7m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-17 at 14:43 -0400, Daniel Barkalow wrote:

> That's the same reason the wireless drivers didn't get merged sooner, wit=
h=20
> the slight difference that they were waiting on the new 802.11 stack's=20
> interface to stabilize, rather than their own interface.
>=20
> On the other hand, it would be good if there were a way to include=20
> unstable APIs in the mainline kernel so that they could get some exposure=
=20
> before they're set in stone, and that would also eliminate that reason fo=
r=20
> keeping drivers out so long.

Small correction here: We actually did evolve the mac80211 APIs quite
radically in mainline (and new API revamps will be landing in .26
and .27).

Most drivers, however, were waiting to be written against the mac80211
API, i.e. there were drivers against net80211 or  (even more of them)
drivers that had their own 802.11 stack in the driver, which meant the
driver needed to be "ported" (rewritten) to mac80211's API.

Stuff like that takes a time when each driver has at best one or two
interested developers.

johannes

--=-Ljb/B3v9GVdNBrKoUu7m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWBETAAoJEKVg1VMiehFYGD0P/RS18LXxNrNaJX/1DpXH23rx
6iTKGkHGXgNxT4W7Ni1q64eLEhbcNKgwyL9dOrjsNPcoKn8ouKfh55ZVZxoeRH/9
+c2rN0Gm4tWZeM+J3l/mKnYyBKUPUHSVyDOZliEe80tTyvHJy4I92cZN5foZtsk5
m4rhu7Jq1sWOyqkwosez0zULEjCAK3YZqFwEJDbKtb2ojtriT7G9ML2racAijFKb
MCw6IYDj+6LmtNdlYW3vUVyVPR3ndHhkOSjutrO3sIqqGcZ1dr93C22aQyvuV8y1
29S5KBp9mtPnjMzNoqo4lQghzO80awJZghpLgf4qSnhqueivwj+sa+nG7HX/1XC8
wpZscsPPYnhXmchZIwvfxYOFaG3SWHeYmBXpCSPdBt2xBozStCL2GpLtvlPiHJx7
HYCm2IGbg+vaIQu2E4uJ1m6qFbhlXrrWKP3vDj4yveW7C0TT9xjxt3KEiHoNh4VN
IUmGvjtv3cb9PI1+TsEGKUcDPmXY9tmQetmBArhHNGLlF8YOqVQL//6wBvvp2FaL
ht9xm9QH5HOrI3LvNlgd71boblVJXOhlJSAFU2jXNOzYUHplh7/tyxVGe6rHZKLN
TDjTA7fhPxnNOQevdLABLwKM/cLhKLiUX6DH8whiFpTNKU01p4kohX/LtNo6RCI/
/D0wydzVE+cDNkxKowDj
=RNk1
-----END PGP SIGNATURE-----

--=-Ljb/B3v9GVdNBrKoUu7m--

