Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZHOOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZHOOab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZHOOaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:30:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:63130 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbZHOOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E629SxOk63ndEyRezUHSLXOjSHzPOjtwOHgNjTKgCe/sIYkmfSgtTUBWOFFY3fHEeK
         w61CSdfWkm28hUJUxWItgLecSl4g9DwLTGUss/Pc28FpwStCVvxwF8RxWUyJyX+AOTO6
         +Pb2cMUjpMI8m4fi0NldVhuyxXl53lAaQ0PA0=
Date: Sat, 15 Aug 2009 17:26:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
Message-ID: <20090815142652.GA7968@localdomain.by>
References: <20090815134312.GA7533@localdomain.by>
 <4A86BC96.9040702@gmail.com>
 <alpine.LFD.2.00.0908150947260.14440@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908150947260.14440@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/15/09 09:49), Robert P. J. Day wrote:
>   it does seem like a DIV_ROUND_UP would be better but perhaps another
> solution would be to define a meaningful macro name for that
> operation.  if that conversion is going to be done regularly, a macro
> with an informative name might be in order.  if it's a one-shot
> operation, though, not much point.
>=20

There are different shr/shl operations in bitblit.c. Like,
cur_height =3D vc->vc_font.height >> 1
cur_height =3D (vc->vc_font.height << 1)/3;
c |=3D c >> 1;
u32 idx =3D vc->vc_font.width >> 3;
etc.

So I don't think we really need a macros here.

	Sergey

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqGxawACgkQfKHnntdSXjTRPwP+N1fSsrnWJRuysB/qRzPeKY/s
UFG2Qgs+ZIt4cmIgFkbl2B4gEvvuRRI4ophqFWCn4Lir1inhogfET2Xm2fxpm5MJ
xZ7S+JxlpACPeGFOPQHdwKg3ZdgxYg129cIvFnHInekm/76+quh+J4UEzXoSK6PV
qzzMkWGJieFhRw0mahM=
=iOGR
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
