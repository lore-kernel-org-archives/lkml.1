Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYBYIzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYBYIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYBYIy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:54:57 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3621 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYBYIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:54:56 -0500
Message-ID: <47C2823B.8080407@imap.cc>
Date: Mon, 25 Feb 2008 09:54:19 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Patrick McHardy <kaber@trash.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <47BD6072.4000407@trash.net> <47BE1A03.30300@imap.cc> <47BE1CE5.1030001@imap.cc> <20080222170908.GA9386@linux.vnet.ibm.com>
In-Reply-To: <20080222170908.GA9386@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A62F2E943E78ECF9CF94C03"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A62F2E943E78ECF9CF94C03
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Paul E. McKenney schrieb:
> On Fri, Feb 22, 2008 at 01:52:53AM +0100, Tilman Schmidt wrote:

>> So the nf_conntrack BUG is fixed, but the crash (and of course the
>> swapper "spinlock bad magic" BUG) persists.
>=20
> Do you have CONFIG_DEBUG_PREEMPT set?  That would help find any other
> bugs similar to nf_conntrack.

CONFIG_DEBUG_PREEMPT=3Dy was set but didn't produce anything.
Or perhaps it did and the message just didn't make it to the disk.
Time to set up a test with netconsole, I guess.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8A62F2E943E78ECF9CF94C03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHwoJDQ3+did9BuFsRAiR5AJ4/uCmh8WnUNZ9XTFwLU9ThzW2aXwCfZRyL
3m5dMAqRrSrbnxxPNe4F+fY=
=i5d6
-----END PGP SIGNATURE-----

--------------enig8A62F2E943E78ECF9CF94C03--
