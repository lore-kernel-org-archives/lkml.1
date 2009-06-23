Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbZFWOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbZFWOha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZFWOhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:37:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:11973 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZFWOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=WeG4c6mZs1fG2OF32ZldI8EHnRLfbpfx/+BNac/62AufIGJKsnbQFj+rfaVBMorkhc
         Lw0VV4o3gdc+iozWuVZIzbtixOR5J+i7IxwfgmEPl0boM/CglT4qTS53iDmQRJ/IWwnx
         F59dZs0hPF0q2yVmExu9O90/JDQJMtV1dDlas=
Message-ID: <4A40E89F.3060207@gmail.com>
Date: Tue, 23 Jun 2009 10:37:19 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com> <4A4029F7.6070502@gmail.com> <alpine.DEB.1.10.0906221808010.10952@makko.or.mcafeemobile.com> <4A402F55.8040501@gmail.com> <alpine.DEB.1.10.0906230728320.16382@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906230728320.16382@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig12CA52104C0D4AD327494B9F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig12CA52104C0D4AD327494B9F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> To be honest, I am not sure.  I would guess its not a *huge* deal,
>> though it was obviously enough of a concern to at least discuss it.  I=

>> can definitely say that I think the other issues which are being fixed=

>> are substantially more important.
>>    =20
>
> Ok then, will repost the revised patch later today.
>  =20

Ok sounds good.  I did have a chance to take a closer look at your
proposal for the key data, and I think it makes a lot of sense.  Do you
see it as a problem if we defer adding that?  Or should we try to add
that notion now?

-Greg



--------------enig12CA52104C0D4AD327494B9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA6J8ACgkQP5K2CMvXmqEKcgCeN32bSS0JrMaMMEf8IMPYilEY
kWYAni+4etAAP0aUbTd5b5hO2kzVN9d3
=0Yof
-----END PGP SIGNATURE-----

--------------enig12CA52104C0D4AD327494B9F--
