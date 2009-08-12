Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZHLX1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZHLX1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZHLX13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:27:29 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:37365 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZHLX12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=g3OO9oRwPYheNN4hmqvi0kDjM3KKNwgscO54t0NyAGfTEiBmsckl5zDVqfHCo2kJY9
         HJEUVM5ZghbzZffiYGLmC3nqpOg/tSSXArkNoID4BlPrWUIEHBjEoZFi6oXcjukoEt0c
         nNJhSJ2jhvK1nXLgTk7nMZHiRNuKbc82MrQYQ=
Message-ID: <4A834E75.9060204@gmail.com>
Date: Wed, 12 Aug 2009 19:21:25 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: alacrityvm-devel@lists.sourceforge.net,
       alacrityvm-users@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM numbers updated for 31-rc4
References: <4A83296B.3080606@gmail.com> <4A834ABB.4010801@codemonkey.ws>
In-Reply-To: <4A834ABB.4010801@codemonkey.ws>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7B8F0D8F7169070E376E2530"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7B8F0D8F7169070E376E2530
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> I re-ran the numbers on 10GE against the actual alacrityvm v0.1 releas=
e
>> available in git on kernel.org.
>>
>> I tried to include the newly announced "vhost" driver (Michael Tsirkin=
)
>> for virtio acceleration, but ran into issues getting the patches to
>> apply.
>>
>> For now, this includes native, virtio-u (virtio-userspace), and venet
>> all running on 31-rc4.  If I can resolve the issue with Michaels
>> patches, I will add "virtio-k" (virtio-kernel) to the mix as well.  Fo=
r
>> now, here are the results for 1500mtu:
>>
>> native:   7388Mb/s,   29.8us rtt (33505 tps udp-rr)
>> venet:    3654Mb/s,   56.8us rtt (17600 tps udp-rr)
>> virtio-u: 1955Mb/s, 4016.0us rtt (  249 tps udp-rr)
>>  =20
>=20
> Just FYI, the numbers quoted are wrong for virtio-u.  Greg's machine
> didn't have high res timers enabled in the kernel.  He'll post newer
> numbers later but they're much better than these (venet is still ahead
> though).
>=20
> Regards,
>=20
> Anthony Liguori

Anthony is correct.  The new numbers after fixing the HRT clock issue are=
:

virtio-u: 2670Mb/s, 266us rtt (3764 tps udp-rr)

I will update the charts later tonight.

Sorry for the confusion.

-Greg


--------------enig7B8F0D8F7169070E376E2530
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqDTnUACgkQP5K2CMvXmqGIPgCeODFW1PfGI0l8mxUszord3Jn8
Of8AnRHOS54KSXmdliDd+XKqcEQZGgSv
=MU0K
-----END PGP SIGNATURE-----

--------------enig7B8F0D8F7169070E376E2530--
