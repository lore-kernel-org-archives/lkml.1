Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbXE3Mj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbXE3Mj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXE3MjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:39:23 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:58628 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXE3MjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:39:22 -0400
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0705291649010.2974-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0705291649010.2974-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MjgFUQxt79JNWQajQZ3W"
Date: Wed, 30 May 2007 22:38:40 +1000
Message-Id: <1180528720.3976.42.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MjgFUQxt79JNWQajQZ3W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 16:55 -0400, Alan Stern wrote:
> The g_file_storage driver uses a kernel thread and communicates with
> that thread in part by means of signals.  It also relies on the thread=20
> receiving signals from userspace as an indication that the thread=20
> should terminate.
>=20
> This was all working in 2.6.21, but as of 2.6.22-rc3 the signal=20
> delivery mechanism (entirely within the kernel!) is no longer=20
> functional.
>=20
> What's the story?  Do I need to do something new and different to get=20
> signals working again?  Should I avoid using signals entirely?
>=20
> Thanks for any help,
>=20
> Alan Stern

Hmm. Given Oleg's reply, it could pay to check that freezable kernel
threads are still being frozen.

I'm about to go off to bed, and am away for half the day tomorrow, but
will check as soon as I can if noone else gets to it first. (Rafael
added for a heads-up, just in case he hasn't noticed this thread).

Regards,

Nigel

--=-MjgFUQxt79JNWQajQZ3W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXXBQN0y+n1M3mo0RAlU9AJsHJXgM8CqtSLH2ebxdIFMTQQdqYQCg0zFm
sMiEylfj8RyrLRKoPHd8WKg=
=S5P+
-----END PGP SIGNATURE-----

--=-MjgFUQxt79JNWQajQZ3W--

