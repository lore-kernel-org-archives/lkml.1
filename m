Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZHZUGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZHZUGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZHZUGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:06:04 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:45629 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZHZUGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=kE8hyYU4Njn8ArA0dZvSnJY3EL8E558Z8PjmifpTtXlvbGZr81lOtSsyWjEu0C5fyd
         BIa46kDjjSe3Q+VLicLhnLOInipoYEm0mQbgULHN+hKffT33t0bsAU7DeLLFUZDDlD9H
         0SMHul5vgB0FEEbHuVBmGXu5OPoj03d/FiucU=
Message-ID: <4A9595A5.9060809@gmail.com>
Date: Wed, 26 Aug 2009 16:05:57 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: alacrityvm-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM benchmark numbers updated
References: <4A948962.7090909@gmail.com> <4A950B75.5020409@redhat.com> <4A95822D.9060207@gmail.com> <4A958BA0.2000801@redhat.com>
In-Reply-To: <4A958BA0.2000801@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8FC4678BFD16BC9A0DD9C085"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8FC4678BFD16BC9A0DD9C085
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 08/26/2009 09:42 PM, Gregory Haskins wrote:
>> Actually, I have already look at this and it does indeed seem better t=
o
>> use switch_mm+gupf() over gup() by quite a large margin.  You could th=
en
>> couple that with your DMA-engine idea to potentially gain even more
>> benefits (though probably not for networking since most NICs have thei=
r
>> own DMA engine anyway).
>>
>>   =20
>=20
> For tx, we'll just go copyless once we plumb the destructors properly. =

> But for rx on a shared interface it is impossible to avoid the copy.=20
> You can only choose if you want it done by the cpu or a local dma engin=
e.
>=20
>=20

Yep, agree on both counts.

-Greg


--------------enig8FC4678BFD16BC9A0DD9C085
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqVlaUACgkQP5K2CMvXmqHoFwCfek8O5cudY+AaXCFINZG7xkl+
7KQAniST0CkgR/J/DWuiquv3L0y3x+oo
=YzEV
-----END PGP SIGNATURE-----

--------------enig8FC4678BFD16BC9A0DD9C085--
