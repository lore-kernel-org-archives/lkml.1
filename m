Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZFWOmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZFWOmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbZFWOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:42:39 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:42022 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZFWOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=GbxQcu5qn9TRtXCEAKoRcRey0Apf3oyEkEnBJ6d2OO/oI0s5XbJidhWwbYCQKNpDv8
         +9oK3t3BIU+HE1nEpRAAW2yIfhBrs2UVsYWwVf6L4w0jZHLWL2Yni86D2ULiJJ84FEbD
         Lt9kxIss9rIBHIjAetDQQ6vH77JCbp+gZU5WY=
Message-ID: <4A40E9DB.4040801@gmail.com>
Date: Tue, 23 Jun 2009 10:42:35 -0400
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
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com> <4A4029F7.6070502@gmail.com> <alpine.DEB.1.10.0906221808010.10952@makko.or.mcafeemobile.com> <4A402F55.8040501@gmail.com> <alpine.DEB.1.10.0906230728320.16382@makko.or.mcafeemobile.com> <4A40E89F.3060207@gmail.com> <alpine.DEB.1.10.0906230732250.16382@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906230732250.16382@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFCB94349B635C63668A2969E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFCB94349B635C63668A2969E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Tue, 23 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Mon, 22 Jun 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> To be honest, I am not sure.  I would guess its not a *huge* deal,
>>>> though it was obviously enough of a concern to at least discuss it. =
 I
>>>> can definitely say that I think the other issues which are being fix=
ed
>>>> are substantially more important.
>>>>    =20
>>>>        =20
>>> Ok then, will repost the revised patch later today.
>>>  =20
>>>      =20
>> Ok sounds good.  I did have a chance to take a closer look at your
>> proposal for the key data, and I think it makes a lot of sense.  Do yo=
u
>> see it as a problem if we defer adding that?  Or should we try to add
>> that notion now?
>>    =20
>
> That would need to go eventually via mainline, after some discussion. B=
ut=20
> yes, I believe that using the "key" as simple bitmask is a little=20
> restrictive.
>  =20

Ok.   As long as you do not think we are somehow painting ourselves into
a corner, lets just go with your original plan for the revised patch
sans key changes.

Thanks Davide,
-Greg



--------------enigFCB94349B635C63668A2969E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA6dsACgkQP5K2CMvXmqHwtwCePQlhfSIWGd2tjRzHxhB2rarO
sgsAnjcpWqLsNEaXjfwPiF+O+Hxi0vAa
=clJs
-----END PGP SIGNATURE-----

--------------enigFCB94349B635C63668A2969E--
