Return-Path: <linux-kernel-owner+w=401wt.eu-S966057AbXDCRbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057AbXDCRbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXDCRbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:31:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966057AbXDCRbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:31:05 -0400
Message-ID: <46128F47.2010107@redhat.com>
Date: Tue, 03 Apr 2007 10:30:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org>
In-Reply-To: <20070403172736.GA23689@one.firstfloor.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBD5530083C9C47CD411D8A64"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBD5530083C9C47CD411D8A64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> Topology is dependent on the number of CPUs.

Not all of it.


> Hot plugging is a completely orthogonal problem. Even your original
> proposal wouldn't address it.

Nonsense.  Reading /proc/cpuinfo or /sys/devices/system/cpu reflects the
current CPU count.  The information read would (and is not) cached, it's
re-read every time.  We might add very limited caching (for a few
seconds) but that's as much as we can go.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigBD5530083C9C47CD411D8A64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEo9I2ijCOnn/RHQRAhFjAJ9ypUSS1ti6B5XEqzSpH/sGjCWONACgjPIq
un8oFDduxOZMiRabwlTJGG4=
=MpLW
-----END PGP SIGNATURE-----

--------------enigBD5530083C9C47CD411D8A64--
