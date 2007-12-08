Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXLHIy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXLHIy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbXLHIyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:54:22 -0500
Received: from sitemail2.everyone.net ([216.200.145.36]:35480 "EHLO
	omta09.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728AbXLHIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:54:21 -0500
X-Eon-Dm: dm02
X-Eon-Sig: AQF97PZHWlu8RC1JCAIAAAAB,07deeb28ad0cd466c282ac85ab17b4a7
Message-ID: <475A5BB3.8040909@smsglobal.net>
Date: Sat, 08 Dec 2007 16:54:11 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com> <474FF0FE.50208@stellatravel.co.uk>
In-Reply-To: <474FF0FE.50208@stellatravel.co.uk>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig36392EC5F6856588D274711B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig36392EC5F6856588D274711B
Content-Type: multipart/mixed;
 boundary="------------090404060204050609080100"

This is a multi-part message in MIME format.
--------------090404060204050609080100
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ben Crowhurst wrote:
> Lo=C3=AFc Greni=C3=A9 wrote:
>> 2007/11/29, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>:
>> =20
>>> Has Objective-C ever been considered for kernel development?
>>>
>>> regards,
>>> BPC
>>>    =20
>>
I have tried it in a toy kernel. Oskit style. The code reuse is very
high specially with string ops and driver interfaces. Its also very easy
to do unit testing with. My main problem was the quality of the compiler
optimization. Its just not good enough. I think if the compiler can do
the right kind of optimizations correctly then a low overhead OO
language like objective-c can be used in a kernel.

On the other hand its the automated testing part that really matters for
me. Imagine adding features to linux week after week without ever
getting a serious panic or two. And then getting a big performance boost
whenever the compiler does more and more optimizations correctly.

>>    No, it has not. Any language that looks remotely like an OO languag=
e
>>   has not ever been considered for (Linux) kernel development and for
>>   most, if not all, other operating systems kernels.
>>
>>     Various problems occur in an object oriented language. One of them=

>>   is garbage collection: it provokes asynchronous delays and, during
>>   an interrupt or a system call for a real time task, the kernel canno=
t
>>   wait.=20
> Objective C 1.0 does not force nor have garbage collection.
>
True.

>> Another is memory overhead: all the magic that OO languages
>>   provide take space in memory and Linux kernel is used in embedded
>>   systems with very tight memory requirements.
>>  =20
> But are embedded systems not rapidly moving on. Turning to stare at
> the ADSL X6 modem with MB's of ram.

Its all about optimizations.

--=20
Democracy is about two wolves and a sheep deciding what to eat for dinner=
=2E


--------------090404060204050609080100
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------090404060204050609080100--

--------------enig36392EC5F6856588D274711B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHWlu5yihxuQOYt8wRAtgSAJ9zMDLf0xpIjaMj48fHjRmFEE+tjACeL6wE
eq+V8k0P0B8Ig0D9l/0kTso=
=zL3/
-----END PGP SIGNATURE-----

--------------enig36392EC5F6856588D274711B--
