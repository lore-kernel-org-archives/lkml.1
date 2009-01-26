Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZAZLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZAZLfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZAZLfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:35:39 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:38474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZAZLfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:35:38 -0500
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
In-Reply-To: <alpine.LNX.1.10.0901261220150.5377@jikos.suse.cz>
References: <1232635779.4224.12.camel@johannes.local>
	 <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>
	 <1232968513.20525.1.camel@johannes.local>
	 <alpine.LNX.1.10.0901261220150.5377@jikos.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4bctg9AR+PTE2Mqq0uDE"
Date: Mon, 26 Jan 2009 12:35:32 +0100
Message-Id: <1232969733.20525.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4bctg9AR+PTE2Mqq0uDE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 12:25 +0100, Jiri Kosina wrote:
> On Mon, 26 Jan 2009, Johannes Berg wrote:
>=20
> > > > Ever since 2.6.29-rc, I see this in powertop on my macbook5,1:
> > > > Top causes for wakeups:
> > > >   24.1% ( 27.8)   USB device usb1 : OHCI Host Controller (Linux 2.6=
.29-rc2-wl-di
> > > >   21.5% ( 24.8)       <interrupt> : ohci_hcd:usb1=20
> > > >   14.5% ( 16.7)   USB device  1-5 : IR Receiver (Apple Computer, In=
c.)=20
> > > > which is way way more than what it used to be, I never saw the IR=20
> > > > receiver before. I could bisect, but wondered if somebody had seen =
this=20
> > >=20
> > > What driver is bound to this device? (what is the product ID?).
> > None, oddly, it seems. At least listing input devices doesn't seem to
> > show it.
> > Bus 003 Device 002: ID 05ac:8242 Apple, Inc.=20
>=20
> This should be driven by hid-apple/usbhid. Could you please look into=20
> /sys/bus/usb/devices for this device and check where does the 'driver'=20
> symlink point to?

driver -> ../../../../../bus/usb/drivers/usb
3-5:1.0/driver -> ../../../../../../bus/usb/drivers/usbhid

> Also, for this device, we force a creation of hiddev node, so it's=20
> possible (and, in fact, probable), that some lirc process has the node=20
> open and wakes it up periodically? (I think there is a macmini lirc=20
> userspace driver, please check whether it has the hiddev node open).

Nope.

Is it possible that I was just in an environment where there was lots of
random infrared traffic that the device picked up? Is it possible to
disable it completely?

johannes

--=-4bctg9AR+PTE2Mqq0uDE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfaACAAoJEKVg1VMiehFY5gAP/3u8/25awHVB3JqjWyxzZlN4
51hH/TSTn12KI+6LbD8vIDbzutIBfmbpf/7hyGUtSiEwC4aUSF+0n9jTZijxZQQ9
m2sdnw7AirLj2qajRtxxfULUSKPZ9Z+aslhK6olplxhOG84bF4ZwYbFlFLDYpmKk
ElU5E+SmCgodbO5mRKkPLY7o5KjYqWH2IYScqT8UJXuCmt1WF3c98cr5nQJRiGnV
XG6O7ZzWocD3Ia/jHGtq/UMzkMH1GxgjzIRc8R9QJQsLnBctnxfrwzHY1A7Rh7Kx
lubz5NxloleMJgIg1+eMcczgrlPN5/OZ5tP+Rc2Es0f9D1yWd2NW61r8aGB9Xs4X
aPhhk1ClezrmSBhvnDc5n3RdzSa00vCeRvdP3G6SpaOJGMk/PmRi8X3kU2hQjso6
46m/zD+MigYhu+Bd4NCheNcGocmo8mLgPtl7iQ1QRNgc+IQFDN22nuuftmZNxuC8
zyX2v8k5mp7BUlupHwfJ7l1RXXSptARvR/UKVO8TFgxXRUbQFyVd3qT8mldDtDka
4DUQKlYp9oZ6NsWtaR4AOuucmrs2t7yDr2nOSYFb9K5gQYbwui7JHkw4RFk4OgOK
8wQylDCoGLx0UKbKFJKRTYeqy1cuG139EbFHeqX5vn4H4yFTFfOfoViGMGwpEaqu
/6tvCay1lN9O4KnGIgmV
=DNmH
-----END PGP SIGNATURE-----

--=-4bctg9AR+PTE2Mqq0uDE--

