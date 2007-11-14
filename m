Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXKNPZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXKNPZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXKNPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:25:00 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:58514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbXKNPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:24:59 -0500
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
From: Johannes Berg <johannes@sipsolutions.net>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: Nathan Lynch <ntl@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, linux-usb-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org
In-Reply-To: <20071113220235.GB9008@frodo.home.lxtec.de> (sfid-20071113_223206_673826_1DF5E633)
References: <20071024120739.GA4897@aragorn.home.lxtec.de>
	 <20071024124109.GA9442@frodo.home.lxtec.de>
	 <20071104032006.GG9695@localdomain>
	 <20071113220235.GB9008@frodo.home.lxtec.de>
	 (sfid-20071113_223206_673826_1DF5E633)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9BlvnStGwQFYaBtSr9Fr"
Date: Wed, 14 Nov 2007 16:26:04 +0100
Message-Id: <1195053964.4091.20.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9BlvnStGwQFYaBtSr9Fr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


[FWIW, my powerbook worked with -rc1]

> 2.6.24-rc2 works so lala :)

> b43 doesn't authenticate via wpa (bluetooth isn't loaded):
> WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Client V3.=
1.0

Those error messages are unrelated. My b43 works fine, even with a
multi-MAC patch.

> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> sysctl table check failed: /kernel .1 Writable sysctl directory
> Call Trace:
> [c1061e60] [c0008b28] show_stack+0x4c/0x1ac (unreliable)
> [c1061ea0] [c0047354] set_fail+0x50/0x68
> [c1061ec0] [c0047784] sysctl_check_table+0x418/0x714
> [c1061f30] [c00335b8] register_sysctl_table+0x64/0xb4
> [c1061f50] [c033fd5c] register_powersave_nap_sysctl+0x18/0x2c
> [c1061f60] [c03391e4] kernel_init+0xc0/0x2a0
> [c1061ff0] [c0011a58] kernel_thread+0x44/0x60

This has been fixed.

> There is a lot to do, but it seems to be a big, big code change in
> that version. This impressed me by looking at the git changes and
> the size of patches. And the rc's don't seem to be frozend versions.
> A lot of new code comes in....
> Let me know whether a complete dmesg is needed.

What is the problem? Why is this on wireless? It'd help if you'd make
one message per problem and post it to the correct mailing lists.

johannes

--=-9BlvnStGwQFYaBtSr9Fr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzsTi6Vg1VMiehFYAQJNJw/+Pj5JorY16GS7vSIzycZDQ33Rz/UxYVmi
ivZHJ6BxZFkWIfmVbKV1WhQQWSnhJYeKFLn6YXzh8pX4YM8fFv7Cf13KNZTzBagE
u0HwF4ZBg7Lmy1qLu752vOfo/JeFOz8Khoj5D/S7yVhm1fBBq0LqZ+s+fmOrQ/fj
Y21EDNNUUnZpwLYLKoSpd9raE01TDde/gWfFuwgEKVol7FtHmH9mkWuuott/HAX8
ehX31M/O3X1csPozTOVXu57PTLu40NWHRUzTJB9ykjE/Ka//zoa0e84h/FmLyz0b
jZj//hW6OuPJUotlCrUZuHOXiK7OVB/x70hTxyvgraUrb/shUUtMEykYMy9xM4Xw
efAVPPD0RvhyAJQFBnWh6QPzoaEjejtGRjNp1ucFIeuPShnVeWAYuVU0Gn6bAEoz
5xPVFZpDMDvOU+QKg4ltw/MHrXthQNnrq/92YuKL8ZSCOJfD37cYlVcMU6FG7ufM
61A+8ivVYQ2155XKVt2umlUt+DhRO4EfBEj2eHo7LuccYT+CoPmiv+MJcnE0AbUi
vdoLPQ/KMs16Jfsvf8uSU2ZHzwOqFlQFv4W7dn2vvWFXuO9wk7NbrWvaN8e/+PUL
0Ey+NzOhY80ecbD6QkUGYIWrv/miCe07N3n/Mr3nyVSQg4iseSqElWDd/6WXmAhH
ZtnSiaVeMZM=
=/EOC
-----END PGP SIGNATURE-----

--=-9BlvnStGwQFYaBtSr9Fr--

