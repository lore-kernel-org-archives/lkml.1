Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZLISXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZLISXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZLISXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:23:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:47399 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbZLISXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=o4NoTb0kYuV93A/vDLRI6vxKHgYLrlCuJs3aJSp/+9LZhAeMAq3ZXgarbbIOqk+rl3
         mOJOw0/rCmT1HOEBLZBaLmVAias5uhNap4NZsC3QPq5iJoOiucqeegPYJK94Gbl71Evg
         PmVuHQO/o/8yk87yPMxq+qS1odusPUt+XcTKo=
Message-ID: <4B1FE99C.9070205@gmail.com>
Date: Wed, 09 Dec 2009 13:17:00 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alacrityvm-devel] alacrityvm-next: clearly specify ioq endianness
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig50B33921B572F5A6A3D0B17D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig50B33921B572F5A6A3D0B17D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/8/09 3:57 PM, Ira W. Snyder wrote:
>=20
> This is a respin of the previous patch series against alacrityvm.git's
> linux-next branch, to facilitate easier merging with the linux-next tre=
e.
>=20
> The SHM_SIGNAL and IOQ code is meant to be used for communication chann=
els
> between systems with different bit widths and operating systems.
> Conceivably, this could include systems with different endianness as we=
ll,
> for example, using QEMU on x86 to emulate a powerpc.
>=20
> This patch series annotates all shared structures as little endian, and=

> fixes up all users. This means that there is no overhead in the most co=
mmon
> case, x86-on-x86. The byteswaps compile out.
>=20
> [RESEND: added LKML to CC per Greg Haskins' request]

Applied, thanks!

-Greg


--------------enig50B33921B572F5A6A3D0B17D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksf6ZwACgkQP5K2CMvXmqGjBQCfVt04XLVZuKS5Eizlr4yVEf4c
ps8AoITRzWt1dcRnqWWK1kXt7iBrmRYi
=CaN0
-----END PGP SIGNATURE-----

--------------enig50B33921B572F5A6A3D0B17D--
