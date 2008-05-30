Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYE3InU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYE3InU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYE3InB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:43:01 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYE3InA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:43:00 -0400
Subject: Re: 2.6.26-rc3 - appletouch resume "incomplete data package"
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: oliver@neukum.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <b6c5339f0805291956j1d39b728n6482003d4b79141b@mail.gmail.com> (sfid-20080530_045702_923794_B79C8717)
References: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
	 <1211800004.17151.51.camel@johannes.berg>
	 <b6c5339f0805291956j1d39b728n6482003d4b79141b@mail.gmail.com>
	 (sfid-20080530_045702_923794_B79C8717)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/AviL3Y25sia2XCO1XIX"
Date: Fri, 30 May 2008 10:41:43 +0200
Message-Id: <1212136904.10109.21.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/AviL3Y25sia2XCO1XIX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 22:56 -0400, Bob Copeland wrote:
> On Mon, May 26, 2008 at 7:06 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2008-05-25 at 16:24 -0400, Bob Copeland wrote:
> >> This appears to be a regression since 2.6.25.  After resuming, I get:
> >>
> >>     appletouch: incomplete data package (first byte: 2, length: 4).
> >>     appletouch: incomplete data package (first byte: 2, length: 4).
> >>     appletouch: incomplete data package (first byte: 2, length: 4).
>=20
> > I have intermittently seen this problem happen for quite a while, a
> > bisect will probably not help you.
>=20
> Hmm, well the console switch in suspend may be triggering it, but I
> didn't have the issue in 2.6.25 and it seems to be easily repeatable
> for me in .26 so far.  Doing ctrl-alt-f1 to switch to text mode and
> back a dozen times didn't break the mouse, but suspending once did.

Oh I didn't say it breaks, the thing is I get this message once a while
without it breaking, while suspend once a while breaks it (but I'm not
sure the message happens when it breaks)

> I tried a bisect anyway but didn't come up with any smoking gun.  Darn.

Yeah, I tried looking at the code but didn't really find anything
either. There must be something else... The thing is, nothing makes
sense unless there's a bug elsewhere, because it works fine after you
resume broken and reload the module. But reloading the module doesn't
really do anything to the hardware, it only submits a new urb while
resume simply resubmits the old one. All the other code is
kernel-internal housekeeping stuff.

Or can the urb endpoint information change so we need to re-do
usb_fill_int_urb?

johannes

--=-/AviL3Y25sia2XCO1XIX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD+9xqVg1VMiehFYAQJTxA/+M3qo0VmFnH9G8d6gS20ZdU2ZtO9+i+Bq
xP19fKqFjqZgBJNY7I+Cpvy5n1Z0q16bulTmoWe6/C0XjaVWr217O+3mY2vjKrIc
qAyHh49NWArd0B5w/l1z6x6z3vHAwPlYpRZvvU/c3hiksroAqlM+BomLr5gkNHIi
K1OW6WoSzNUZW0cC+r5CvTbU7A11Xl07Z0IsXNxyFfwiOIUYCDaLYcqGNlYUPw/y
sa2ETu1fl5mR6qAeJEWm1bBFy845ObaYARCOy2sOB9jvDpj0nFNKz5aC0Z0kRSQK
NpeqC6jGxDIeHYBHGmBvdxfr1BogdZvxXtEPKqZSpsIyctIWKRDa5A7gSVzU9SOZ
HMp5JH4enOFnmSccvMLpqLcv/I0iFdHzL/y/ntOweqdxXhV6OS8rUndop4fEdwwn
gJi724mZABZ7VaEEQqvmRZ9UwxIy0PpV0e+J5xG89evXQy2wDT6eQ1DLEqA+bpNB
Tk8AvZU21w7EJ1P3aXiOT5m8cfmLhNUsS3pZOmPh5owT0SMOp63lMqR5p/VAHuRD
Y0ioW/z7fs3g1Uw0MjgHTTvNkVwjWHIO9r9M1HVo77CFpDwJpVhQAZoOzxKnpXs6
LOGDozuJPoHPm0sY06vcrtQy9pM3zTBdHn1/C8/7c+YbOZbKPEQTHKSznwGw3Pl4
373Wz9WTuQ0=
=0EL/
-----END PGP SIGNATURE-----

--=-/AviL3Y25sia2XCO1XIX--

