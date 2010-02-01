Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0BAMxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:53:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42082 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0BAMxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=K2shclABUUNAn0jRjamFIwRktq4P3kzFXfPyW/0b1/FaEcOGEwpscNCyUqkgMro1hn
         FHjs2RVTLXxA0EOKtNEjFITCr3xcEyApT6GZNV9YiyDu4EYeD/7yIKdsp1cV362lRFjV
         9T0AU8g+87BlY7XoqJO1uObk/Xiksnonxw5WM=
Message-ID: <4B66CEB0.2050806@gmail.com>
Date: Mon, 01 Feb 2010 07:53:04 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kaber@trash.net, arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] vbus: venet macvlan rt netlink changes
References: <20100114215058.4958.87746.stgit@mimic.site>
In-Reply-To: <20100114215058.4958.87746.stgit@mimic.site>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig01EC002098C79086720765C9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig01EC002098C79086720765C9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 1/14/10 4:52 PM, Patrick Mullaney wrote:
> (Applies to alacrityvm.git/master:a725f9950)
>=20
> This series changes the venet macvlan device such that it can
> be created via rt netlink and no longer requires any extensive
> changes to the macvlan device itself. The first patch removes
> prior changes to the macvlan device introduced in the alacrityvm
> tree and also implements the changes needed for creation and
> management via rt netlink. The subsequent patches(2 and 3) are
> changes to the macvlan device for GRO support and for type
> specific release. These 2 patches don't appear to be upstream.
> If desired and approved, I'll regenerate these last 2 for
> net-next.

Applied to alacrityvm.git/master.  Thanks Pat!

>=20
> ---
>=20
> Patrick Mullaney (3):
>       macvlan: use rtnl_link_ops->dellink during unregister notications=

>       macvlan: add GRO bit to features mask
>       venet-macvlan: allow rt netlink to create venet macvlan devices
>=20
>=20
>  drivers/net/macvlan.c                   |   72 ++----
>  include/linux/macvlan.h                 |    6 -
>  kernel/vbus/devices/venet/device.c      |    8 +
>  kernel/vbus/devices/venet/macvlan.c     |  360 ++++++++++++++++++++---=
--------
>  kernel/vbus/devices/venet/tap.c         |    3=20
>  kernel/vbus/devices/venet/venetdevice.h |    3=20
>  6 files changed, 265 insertions(+), 187 deletions(-)
>=20



--------------enig01EC002098C79086720765C9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktmzrAACgkQP5K2CMvXmqGP0gCfd8f04M8xSxKJdQ5dSKexNR8b
kPIAn3E8C+rHpDEs15tNAhi5GHCx7Rwn
=oF+7
-----END PGP SIGNATURE-----

--------------enig01EC002098C79086720765C9--
