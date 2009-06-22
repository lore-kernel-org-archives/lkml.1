Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZFVOj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZFVOj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFVOjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:39:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45971 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFVOjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:39:19 -0400
Message-ID: <4A3F978C.1050201@novell.com>
Date: Mon, 22 Jun 2009 10:39:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F8170.7000508@gmail.com> <20090622131351.GE12867@redhat.com> <4A3F84FD.3090700@gmail.com> <4A3F957A.6000501@redhat.com>
In-Reply-To: <4A3F957A.6000501@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0DBE7E5463CECE5D8C307FD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0DBE7E5463CECE5D8C307FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/22/2009 04:19 PM, Gregory Haskins wrote:
>> The question to ask is whether a guest can influence that condition.  =
If
>> they can, its an attack vector to crash the host.  I suspect they can'=
t,
>> however.  Therefore, your recommendation is perhaps a good approach so=

>> this condition cannot ever go unnoticed.  Avi?
>>   =20
>
> No, this is host memory in the emulator context, allocated as unsigned
> long.  But this is on x86 which isn't sensitive to alignment anyway.

Ok, will change to BUG_ON in v9

> It's unlikely that other achitectures will supply unaligned pointers.
>
Yeah, they shouldn't

> We ought to convert the interface to pass a value anyway.
>
Agreed.  As you said earlier, lets defer for now.

Thanks Avi,
-Greg


--------------enigD0DBE7E5463CECE5D8C307FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/l4wACgkQlOSOBdgZUxknXgCfbpq6wWHbhZE6jq3tOS8iRh7A
qzcAniTYq35+KwMx5JHH8iuPKgHYKdL9
=JoY+
-----END PGP SIGNATURE-----

--------------enigD0DBE7E5463CECE5D8C307FD--
