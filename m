Return-Path: <linux-kernel-owner+w=401wt.eu-S1030494AbXAaSVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494AbXAaSVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXAaSVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:21:05 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:38329 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030494AbXAaSVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:21:03 -0500
X-Greylist: delayed 1831 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 13:21:03 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=JtOs02ypLiReBADyS6TdcV/9xlhbGxBuyrt+w74W6sW7Mc8qg2Pa1WyCrGGACkb13/1m590ecBKorA8J38pWq4iMr6PJFwLSKKLnKVH0CU9c/fjs9NVcKdqM485z2VDD;
Message-ID: <45C0D6E0.2090707@simon.arlott.org.uk>
Date: Wed, 31 Jan 2007 17:50:24 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usbatm: Allow sub-drivers to handle calls to atm_proc_read.
References: <45BFB6F1.2070303@simon.arlott.org.uk> <200701311548.13076.duncan.sands@math.u-psud.fr>
In-Reply-To: <200701311548.13076.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig59CBB62FDFCD28A365F23A7F"
Reply-To: Simon Arlott <99d904aa15c87e3aea1hcjbh0000q9ju@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59CBB62FDFCD28A365F23A7F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/01/07 14:48, Duncan Sands wrote:
>> usbatm only outputs basic information via the per-device /proc/net/atm=
/ file,
>> this patch allows the device specific USB ATM drivers to replace the
>> atm_proc_read function with their own. =20
>=20
> I'm still meditating on this.  The reason I didn't do this originally i=
s
> because of potential problems with modem disconnection and/or module
> unloading (the cxacru module can be unloaded at any time - it's the usb=
atm
> module that can't be unloaded when a connection is open - so you've got=
 to
> be careful that no-one can call into cxacru after or while it's being
> destroyed).  I think it will be OK as long as usbatm calls unbind after=

> shutting down the ATM layer (since otherwise your read method could be
> called after you've freed your cxacru private data) which is not the ca=
se
> right now, but should be easy to arrange.  Horrible things may happen
> if proc_read can still be running after atm_dev_deregister has returned=
,
> but, if so, horrible things can already happen right now.  I don't unde=
rstand
> why this is impossible; maybe it is possible.  The worst that will happ=
en
> (given that none of the proc_read methods sleeps) is that freed memory =
will
> be accessed and the contents spat out in the proc file (if proc_read sl=
eeps,
> that could result in trying to run code inside a destroyed module).
>=20
> Ciao,
>=20
> Duncan.

Couldn't the cxacru instance pointer to the proc_read function be set to =
NULL before unloading?

--=20
Simon Arlott


--------------enig59CBB62FDFCD28A365F23A7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRcDW4KRtx1WjQ8ihAQoP2Q/+Ob+ToISls3wsPHQOHrSKIZcNdx7QkkTX
pG39+wEMC13DgMcccBhUqJ9g0YlJe7l3SqVTF0q7u7StYOOPKee2wmmNSTv7j+Ih
M6dIEsNqgwFID32Xk+eWru7rCzfMEkO/1w3U8uGFco3Zdv7D39J39jLA37C83yVm
B6CWWjPY5Oy5bKBkkXZdNXKJa7w6Cr8gUhKuRt/+RFf2WoEkdUJtimdGbM32VTRD
K1oN9/S6TbLP+FpKvhf1tI+/eSBoy+W2OwzMwOBG72K9uDVxuXl8WMbQU3RXfEiK
idh2XaV+5HV3H8FqDTLSFg1idh3iM1mC1CRCtTLxD2aRGn7AQ8EmVYZRwkthpVmy
K7bI90E8zblhsNs7Hn/ZT1xXzciH+Ck4RFxDUI6WhmYIw2nIt3G5HMkwbIB/5q6V
v0lVFgy8gas3i7naWIeCa4N/djiwf5eBTscNQs/jlM56s2q4U4krPT3FHuZ+hUqt
Si/lSdzHKmSaYmZYTFF7gCssceNra9PDaa+vSaJwFNzzmmOwZ856gK6RJe3HeJZJ
9JR4YzM0yfuA2Pv5G8yT+xdC4oBo+L6DgYE+ep5Zsqjt2s1bIyq0IZRuitzeu2JS
mO4Makpur9hpgvFxVg+ok/ZWTRtFfiS+xm/IUuWoMbU0+GO8xGR3BEudNmfIN6Dk
lXeplyFB4pk=
=97lO
-----END PGP SIGNATURE-----

--------------enig59CBB62FDFCD28A365F23A7F--
