Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDCTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDCTzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbXDCTzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:55:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXDCTzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:55:40 -0400
Message-ID: <4612B12A.30609@redhat.com>
Date: Tue, 03 Apr 2007 12:55:22 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com>
In-Reply-To: <20070403174457.GA15704@linux-os.sc.intel.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig249489960970D2EECC4B721E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig249489960970D2EECC4B721E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Siddha, Suresh B wrote:a
> Not all of the cpu* directories in /sys/devices/system/cpu may be
> online.

Apparently this information isn't needed.  It's very easy to verify:

$ ls /sys/devices/system/cpu/*/online
/sys/devices/system/cpu/cpu1/online  /sys/devices/system/cpu/cpu2/online
 /sys/devices/system/cpu/cpu3/online

This is a quad core machine and cpu0 doesn't have the 'online' file
(2.6.19 kernel).  So, if nobody noticed this it's not needed and we can
just remove CPUs from /sys/devices/system/cpu when they are brought
offline, right?

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig249489960970D2EECC4B721E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGErEq2ijCOnn/RHQRAs3SAJ0TxAH/SgZcHTph2GltSbJQzVDJtgCgiE/S
2huYMgZfRRKFNbt51tJZ59E=
=QyA/
-----END PGP SIGNATURE-----

--------------enig249489960970D2EECC4B721E--
