Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZAVOuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZAVOuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZAVOto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:49:44 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:46184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZAVOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:49:44 -0500
Subject: since 2.6.29-rc: apple infrared keeps system awake?
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o7RKCwmrqzC4/3JUgayP"
Date: Thu, 22 Jan 2009 15:49:39 +0100
Message-Id: <1232635779.4224.12.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o7RKCwmrqzC4/3JUgayP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ever since 2.6.29-rc, I see this in powertop on my macbook5,1:

Top causes for wakeups:
  24.1% ( 27.8)   USB device usb1 : OHCI Host Controller (Linux 2.6.29-rc2-=
wl-di
  21.5% ( 24.8)       <interrupt> : ohci_hcd:usb1=20
  14.5% ( 16.7)   USB device  1-5 : IR Receiver (Apple Computer, Inc.)=20

which is way way more than what it used to be, I never saw the IR
receiver before. I could bisect, but wondered if somebody had seen this
before?

johannes

--=-o7RKCwmrqzC4/3JUgayP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeIeAAAoJEKVg1VMiehFYWogP/3OPjf8RPnpbBd4ToqHBjFue
+351OHCeyntTHNGobSo57FmLnPOoda44MSbhMw7hQdiUw2Dm71tkW+5Hj1uLHnim
My5yeuOAyGDyZCw87FAeHJzJXo6QhRXcuz9XyM8arOpJNu/0tVTYdlhyf0wuR8zP
dhh0/9kPON1nYR9fQq2q/IIsdxxTPeLeaxmhMaghzF0E4iVGxpvwzzQuUrHa3lmC
GVVDeD9ZbCzmYYZMXRxvppNgP5wP58auO+ZgdezIj7s4GLvRZcrCm6egDWKrckUD
CvcZTAQ4AFxbR4Q4J28ddz5+13ObPYnGNNVsO6VRSjWS9ornMxBX9nZ8CLFKgDhP
7cyHqpC3gFVZZeXfzxXRPft6g8SdpvDjYi2+6aTHZ7DGefAecspBPueNEfpNde9Z
J8b8ZmCdQIGUWZsPySKvgZkNn0YTh8e5ug1/Z+yoT3+0Yv9IpgO96WgBh6Mwh/qa
frYlKws3jjfGAz+aXmlNS8DrjtoxyhxdUDcu4JeNzKHzrarABAwmqYski3mqQZst
yIfDXAExNBMlZ9CCPaKLaoWWRThab7KiNU3Ikm+FV+6biwhuFsI9tAKn8y8vCpSg
CgeFvNAEEPLOMvgw4Ei5UqxhVmjQ0ILcHbOAc3Npj9VhvmX9odcNtTF14kXA7HYs
iFs3mnuLsSlsLD1cZcGW
=cYWz
-----END PGP SIGNATURE-----

--=-o7RKCwmrqzC4/3JUgayP--

