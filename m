Return-Path: <linux-kernel-owner+w=401wt.eu-S1751271Ab0AAGXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab0AAGXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 01:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808Ab0AAGXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 01:23:53 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36872 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0AAGXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 01:23:53 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dev@uclinux.org
Subject: Re: [uClinux-dev] [PATCH] Valid relocation symbol for FLAT format on ARM, v2
Date: Fri, 1 Jan 2010 01:23:48 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32.2; KDE/4.3.4; x86_64; ; )
Cc: Jun Sun <jsun@junsun.net>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
References: <20100101012645.GB16887@Pogoplug>
In-Reply-To: <20100101012645.GB16887@Pogoplug>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3372833.GAgyqHDoex";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001010123.49951.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3372833.GAgyqHDoex
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 31 December 2009 20:26:45 Jun Sun wrote:

when posting updates, you should put the "v2" and such inside of the "[patc=
h]"=20
marker like so: [PATCH v2].  git will remove this automatically when applyi=
ng.

>  #define	flat_old_ram_flag(flags)	(flags)
> -#define	flat_reloc_valid(reloc, size)	((reloc) <=3D (size))
> +#define	flat_reloc_valid(reloc, size)	((reloc) <=3D (size) + 0x1000)
> +/* [jsun] new gcc 4.x generates ANCHOR symbols in order to reduce the si=
ze

comments go above the thing they're documenting, not below.  the "[jsun]" i=
s=20
also not really useful -- no one who reads this after the fact will have an=
y=20
idea what "[jsun]" means.
=2Dmike

--nextPart3372833.GAgyqHDoex
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLPZT1AAoJEEFjO5/oN/WBK+QP/1HiHn4+KQrM6K5K6N9viy8d
JiVvjhd1RrrSAg81Fi2moUepH+zs8TvcWs9zXwsg8V/XY3SLYJkACjLpsuS5Qh81
UmdqX2K1sqI7YvOHoc26zUXTqGBIjp/1WcIGvLnjdaEEBriOU785C2rOukoWfOqm
CpoQT4zPl0MGVSJJ3cMJQoMI8K1tEU5J94wt4420uNzVffSiVG165pgmIcMDlD00
sDnNo3eIun1+5SC8ZA3YbRt1gTIsfqDAlZkWTlD49/8sYJQJlS47l8m5nJebjt3o
VBrAF2UMjsxvWtZIXXXdrLhAEDIGQhgsEkcSuKgqOquDgxTiPOdpr98YYEZPLa+3
6qDq8THM3e11BtnUrO4AuitJwDjSJmtAlI6JWtz2alvGzztkFazscyc4dqj1CKh9
IDfxx8dLVN83iIU03Y00KotgUnNuolFsLJih8aBMWT6QYjGc1YTZ/rI3eSt06n8N
erJKjlbOYYqM20YLDDwNMDXyNL6dY5QxYA0UdxBqPHyYwxtSqJO7Ih5191XAj6eS
uZdcSbLCQ7lr6mS7X5Ni/PgsEywV6NcB6I9FuVoFOnRVHg8aikY9QRfaRgTdfoQb
ZREfmtnnciO6sG/9XfVCXqKc7sFH3VyL0RYzsPWsBZM96xaFwbiJeBGcSNPrLLmp
kMFCKKC57w0PSNaSuEcV
=Lhfv
-----END PGP SIGNATURE-----

--nextPart3372833.GAgyqHDoex--
