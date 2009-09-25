Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZIYKm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZIYKm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIYKmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:42:25 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:36524 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZIYKmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tMMVWqlxzDCHSz17ORFb7HG8c/+LsUqsp+BrtG7eWb5gC030tnlcniUXz8WujPQZTs
         6INQ25PkOJ4FR+3bNa4NJZezvZEXkSvpaGBVG1486GphEPHOBzQHYEERmbKIIwmuA+v0
         t99pB7L6mcHN9W7Yljk8/1/tOJddyYp97VZ/4=
Date: Fri, 25 Sep 2009 10:42:03 +0000
From: Andy Spencer <andy753421@gmail.com>
To: "Am??rico Wang" <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix %*s%n in sscanf
Message-ID: <20090925104203.GA11323@c.hsd1.tn.comcast.net>
References: <20090925062734.GA9318@c.hsd1.tn.comcast.net>
 <2375c9f90909250002o59d5d375i8a670494db02287a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-11380-1253875347-0001-2"
Content-Disposition: inline
In-Reply-To: <2375c9f90909250002o59d5d375i8a670494db02287a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-11380-1253875347-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >   int end;
> >   char buf[] =3D "hello    world";
> >   sscanf(buf, "%*s%n", &end);
> >   printf("%d\n", end);
>=20
> Yeah, seems reasonable. So, without your patch, sscanf() in kernel
> will ignore everything after '*', right?

Currently it ignores everything between '*' and whitespace. So '%*s%n'
does not work, but '%*s %n' will correctly return the start of "world".

--=_c-11380-1253875347-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq8npMACgkQz1OYJ/s1XTAhhACdH+GPfUTfaKshpIDNItR3LSDJ
Nd8An2jgMhGgbwaCZ3pPN2osqxqsjiDq
=KdJj
-----END PGP SIGNATURE-----

--=_c-11380-1253875347-0001-2--
