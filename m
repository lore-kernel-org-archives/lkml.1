Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZFWLwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZFWLwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZFWLwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:52:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59532 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZFWLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:52:29 -0400
Message-ID: <4A40C1F4.40602@novell.com>
Date: Tue, 23 Jun 2009 07:52:20 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>, avi@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com> <20090623114438.GD17635@redhat.com>
In-Reply-To: <20090623114438.GD17635@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BC3C796EF9EAF0271D97AF2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BC3C796EF9EAF0271D97AF2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 23, 2009 at 12:04:06AM -0400, Gregory Haskins wrote:
>  =20
>>>>  It will also need to support
>>>> multiple matches.
>>>>    =20
>>>>        =20
>>> What, signal many fds on the same address/value pair?
>>> I see this as a bug. Why is this a good thing to support?
>>> Just increases the chance of leaking this fd.
>>>  =20
>>>      =20
>> I believe Avi asked for this feature specifically, so I will defer to =
him.
>>    =20
>
> Hmm. That's hard to implement in my model. Avi, can we give up
> this feature? I don't think anyone needs this specifically ...
>
>  =20

If we can drop this it will simplify the mods I will need to do to
io_bus to support Michael's new interface.

Out of curiosity, what is it you are trying to build Michael?

-Greg


--------------enig5BC3C796EF9EAF0271D97AF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpAwfQACgkQlOSOBdgZUxlRawCgiSpLHwmb83qbluqrF1jq9rWt
0x0AoISGaz3J8bYDe11bIKVQbyBPaK7e
=ip5W
-----END PGP SIGNATURE-----

--------------enig5BC3C796EF9EAF0271D97AF2--
