Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZHGHjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZHGHjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZHGHjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:39:49 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:50509 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbZHGHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FjZ0NFDQyjx14+sQC9acAsLJOIs681ChYaxmZe7YNDmX6o1x8Td7U/uWUFlE8yTBrW
         vK4jWbSqgb6DgaQ0TP7gAgzHGuO6+u8BCobo328bks5Zia6jmWYL7UqY8om6mgzsxZ/t
         ZiYgROf9fB/DcvMcdGeYRYhPleNzJgLiaOlyo=
Date: Fri, 7 Aug 2009 10:42:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2
Message-ID: <20090807074251.GB3004@localdomain.by>
References: <20090806180930.GA3004@localdomain.by>
 <87d478i0d7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <87d478i0d7.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/07/09 08:50), Andi Kleen wrote:
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> writes:
> >
> > Of course, compiler supposed to do something like
> > 	add    $0x7,%eax
> > 	shr    $0x3,%eax
> > instead of div. Should we rely on this?
>=20
> Yes. We should rely on this.=20
>=20

grep -cR '>> 3' bitblit.c=20
5

and only 1 '/8'.

	Sergey

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp72vsACgkQfKHnntdSXjTEZQP7B6BHZEMJ2o/kZAVuF9qxYqVM
wCf9edPCpkgPFY/hNRiLKCuPzhDf9agMAlL1hK1ikVDd8dkyLV7MNtWo6fZjsG4r
/iKwYalSme2y6KGK4s9DfUy/RYi0YzApuV6/f+uaBMCUfZH65fY97twGAvp4AyCc
LsIf8jURvoWZdkewBhU=
=gHJ8
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
