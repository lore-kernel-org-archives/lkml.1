Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYFCRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYFCRuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFCRuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:50:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYFCRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:50:36 -0400
Subject: Re: [linux-pm] [PATCH] add a printk_init variant storing format
	strings in __initdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <1212485252.0@pinky>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	 <1212485252.0@pinky>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Omh/+UuJajw+ueDMyn4C"
Date: Tue, 03 Jun 2008 19:49:32 +0200
Message-Id: <1212515372.27643.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Omh/+UuJajw+ueDMyn4C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +asmlinkage __init int __printk_init(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r =3D vprintk(fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +

Wouldn't you have to export that?

johannes

--=-Omh/+UuJajw+ueDMyn4C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEWEK6Vg1VMiehFYAQLwgg/+KKqdxxoTlI8Sy0ah6x+zoLd2n8dscVuM
x4SjkdsMbocL7g2+PcL0upK2+w9LjylBpl4zAviE5Q62nhMIwwjkeIGeQU54Y1q6
eBV1c5NEp6xS8+9JQYBXizkTVpkUQb0BfKne2O1+TPqLctFuhgxafvRrjjAQERW/
2ZsBRe6Q6dO8nIZBX+PywduOXohsDIiV6cLezBTJCxlw3GHn3IIAvz7JkvcpkEd3
kH4//Uoz66crUasmr01nR7phXub+MzM335//UBk66dFi5KteNApXXiYRYGvaQA+d
TErBJJ1K5/Grk3RaKUsk5QVl6NbCMSt6YyaxQIgizTbPXeMoQH0rEuk+4CJzh17J
T+jOoLGNVQaHS1SyZgI3kgCZWj+aHAgRSw8VYbWJI4xtBtIFXKKGnxDcN/saFxLH
caimbzv6rMrXng8g6dwpDnkU8Bzy94unKeR4yEVWQ8GM+54q4PaM6Fa0dyRe41gK
lymg//lgoB6sIWgCym0pj6fHql90gMamFMT88u7ZOcKEf82DFv/odW5ITjbkG/xU
rj0dlTlWvU4AaqcQqcAxU2SZ2fn+y/eD4DZku5xoAhha4E6naGk7Slt4dTjpB4Ui
is97P8yrPGopaFZGjsW98U84sRa9tRzdkwG0lSt8lFP0Q8U1SXHjtrQ5EjfM3/vu
Alz3zy/rUlg=
=YgC3
-----END PGP SIGNATURE-----

--=-Omh/+UuJajw+ueDMyn4C--

