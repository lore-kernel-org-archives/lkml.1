Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXDCSAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXDCSAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXDCSAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:00:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161042AbXDCSAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:00:38 -0400
Message-ID: <46129619.8050107@redhat.com>
Date: Tue, 03 Apr 2007 10:59:53 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com>
In-Reply-To: <20070403174457.GA15704@linux-os.sc.intel.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C51418F5B4750BA7E185650"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C51418F5B4750BA7E185650
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Siddha, Suresh B wrote:
> Not all of the cpu* directories in /sys/devices/system/cpu may be
> online.

Brilliant.  You people really know how to create user interfaces.  So
now in any case per CPU another stat/access syscall is needed to check
the 'online' pseudo-file?  With this the readdir solution is only
marginally faster than parsing /proc/cpuinfo which means, it's
unacceptably slow.

I cannot believe all these big system people are allowed to screw
everybody else up with their nonsense.

So, anybody else has a proposal?  This is a pressing issue and cannot
wait until someday in the distant future NUMA topology information is
easily and speedily accessible.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig8C51418F5B4750BA7E185650
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEpYZ2ijCOnn/RHQRAibkAJ9WcackAa/1qLAdx8LQ7YKyQxEOwwCcD8Sg
Ot6uNXrMsjNvUNuJ/UdLFG4=
=v+kN
-----END PGP SIGNATURE-----

--------------enig8C51418F5B4750BA7E185650--
