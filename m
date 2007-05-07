Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXEGJzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXEGJzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 05:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXEGJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 05:55:16 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1918 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXEGJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 05:55:15 -0400
Message-ID: <463EF77A.9020808@imap.cc>
Date: Mon, 07 May 2007 11:55:06 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: trying to track a change to drivers/isdn/usb-gigaset.c
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFAC59309B77127C6526248C7"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFAC59309B77127C6526248C7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

While looking for something else I stumbled upon an unfamiliar
change to the file drivers/isdn/usb-gigaset.c in the current
git version wrt 2.6.21. git-blame attributes it to d626f62b
which resolves to:

Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Mar 27 18:55:52 2007 -0300

    [SK_BUFF]: Introduce skb_copy_from_linear_data{_offset}

    To clearly state the intent of copying from linear sk_buffs, _offset =
being a
    overly long variant but interesting for the sake of saving some bytes=
=2E

    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

But I cannot remember seeing that patch via the maintainer
addresses for ISDN or the Gigaset driver, and the LKML archive
doesn't seem to have it either.

Where was that patch discussed? What is its rationale?

And more generally: is there a way to get notified if someone
submits a patch that affects a file of which I am a maintainer?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFAC59309B77127C6526248C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGPvd6MdB4Whm86/kRAus2AJ4x6VDDgJx4EN3H6OEudOdW2rnSWQCfebCx
qjgHD0TVWDzZPXU3yB2hg9c=
=bI0W
-----END PGP SIGNATURE-----

--------------enigFAC59309B77127C6526248C7--
