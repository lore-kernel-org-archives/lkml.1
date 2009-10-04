Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZJDJR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZJDJR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 05:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZJDJR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 05:17:57 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:55544 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZJDJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 05:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=WYZ+BWPdLK7w8k+azc/Pdbf5sfKMelehpHvtBOom92OpJmAa5R8AvlBBw1HGKT96T4
         8R74BG19keWRi7l0avfsfWZMWUqhOMf+NBzPXLxPjAUjLHrh+Tr+L5z1RujIvs16qxoC
         knMLxf8zhjrt5Rj8oR1xNoi63OsgAfK1RaTlM=
Subject: Re: High power consumption after suspend/resume cycle
From: The Holy ettlz <theholyettlz@googlemail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
References: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
	 <cb0375e10910021229x7924ec56o61627ec0f625a70c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tm9hUJjLwqFNzr1bH6Qz"
Date: Sun, 04 Oct 2009 10:17:13 +0100
Message-Id: <1254647833.3845.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tm9hUJjLwqFNzr1bH6Qz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

> > There's a catch, though: after a suspend/resume cycle, power
> > consumption goes up by over well over a watt.  (On a system that draws
> > about 7 watts before suspending, that's a big deal.)  I've tried
> > turning off X, suspending with 'echo mem > /sys/power/state' to avoid
> > any distro scripts running, and manually restoring SATA power saving
> > settings, but it still happens.  I even tried unbinding e1000e and
> > both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
> > iwlcore, and it still happens.  This is 100% reproducible, and I'd be
> > happy to test things.

Just out of curiosity: does it make any difference whether tickless mode
is enabled or not, and do you see an excess of wakeups with no apparent
origin, a la http://bugzilla.kernel.org/show_bug.cgi?id=3D12788 ?

Thanks,
James.

--=20
The Holy ettlz                              TheHolyettlz@googlemail.com
PGP key ID: 03F94B5D
-----------------------------------------------------------------------


--=-tm9hUJjLwqFNzr1bH6Qz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrIaBcACgkQL/Is9AP5S10vUACeKYrLazVLr7XSaA68H2xh5E41
7NAAoIgskYfkaJuOkCnfbJk01RqtcSvy
=qrlP
-----END PGP SIGNATURE-----

--=-tm9hUJjLwqFNzr1bH6Qz--

