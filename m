Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZHQIFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZHQIFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZHQIFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:05:35 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:61118 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbZHQIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uVbAnyJJjKozwXnK2AkJ3h6HpoJ66wpXq/HXIJ1x8MnzlpZNa7vQEsB9Bj58ECqlhQ
         OjP/BH/7gYYMYv3ki8dP1c5VTqeMOstnEiNP9kQo2wTwh6dumvRMQKyPlsW7M7K+T/+P
         oAcDOCzeOo3NN1Z/SEZVt8q4IL4n+dXVfZJls=
Date: Mon, 17 Aug 2009 11:08:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, andi@firstfloor.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] VIDEO: console, use DIV_ROUND_UP
Message-ID: <20090817080853.GC2967@localdomain.by>
References: <20090817073147.GA2967@localdomain.by>
 <1250495293-13035-1-git-send-email-jirislaby@gmail.com>
 <20090817080023.GB2967@localdomain.by>
 <4A890E33.2080302@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <4A890E33.2080302@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/09 10:00), Jiri Slaby wrote:
> On 08/17/2009 10:00 AM, Sergey Senozhatsky wrote:
> > So... In general, ((vc->vc_font.width + 7) >> 3) =3D=3D  DIV_ROUND_UP(v=
c->vc_font.width, 8) - 1;
>=20
> ?
>=20
Oops, silly me. Somehow I thought about
DIV_ROUND_UP((vc->vc_font.width + 7) , 8). My fault. Sorry.

> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>=20
> DIV_ROUND_UP(vc->vc_font.width, 8) expands to:
> (((vc->vc_font.width) + (8) - 1) / (8))
> which is pretty printed:
> (vc->vc_font.width + 7) / 8
> and that's equivalent to:
> (vc->vc_font.width + 7) >> 3
>=20
> Correct?
Right.

>=20
> > Are you sure we really can use DIV_ROUND_UP?
>=20
> Yeah, pretty sure.
>=20
OK.
--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqJEBUACgkQfKHnntdSXjS/3AP9HTYCJz36u8IhDvckOvyqt4CV
CEAkrOqVV8sL6JwnwfiVYEWzUoM7sEvAzmlJyKwCaiRnbcF+RepoTm4l59DslatA
Dii9VyunS6mAeUOCu8Xk3H4EEJIGDHJ9LLBffDrFfJ3ZYvo8Dk0yWUn6+xKPcn6O
hSesCFuVgIOjY15mKAk=
=3hsL
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
