Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZHCUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZHCUYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZHCUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:24:15 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:37061 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZHCUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=tbC9eSeMpZ3at4vRDVXiEKAp+03JxWr9SwfxQlKUF3qLwjh4cPifIE9fYo4wgiSc2C
         4HYSzF5PVzV8jeOuZ/BETtxCsjX9QC2VOt60tLsQebh8Hp4KNu5k5XjqUVfoava+XgGn
         88tHCmihILW0tmLWZxuUpM9xcHgiqIpyjQ8fQ=
Message-ID: <4A77476A.1030001@gmail.com>
Date: Mon, 03 Aug 2009 16:24:10 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 6/7] net: Add vbus_enet driver
References: <20090803171030.17268.26962.stgit@dev.haskins.net>	<20090803171801.17268.93846.stgit@dev.haskins.net>	<20090803113030.3092d5b0@nehalam>	<4A77443D.9020105@novell.com> <20090803131927.6f653556@nehalam>
In-Reply-To: <20090803131927.6f653556@nehalam>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0B70D64D9F73FB923974D8FD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0B70D64D9F73FB923974D8FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Stephen Hemminger wrote:
> On Mon, 03 Aug 2009 16:10:37 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
>=20
>> Stephen Hemminger wrote:
>>> On Mon, 03 Aug 2009 13:18:02 -0400
>>> Gregory Haskins <ghaskins@novell.com> wrote:
>>>
>>>> +
>>>> +static const struct net_device_ops vbus_enet_netdev_ops =3D {
>>>> +	.ndo_open          =3D vbus_enet_open,
>>>> +	.ndo_stop          =3D vbus_enet_stop,
>>>> +	.ndo_set_config    =3D vbus_enet_config,
>>>> +	.ndo_start_xmit    =3D vbus_enet_tx_start,
>>>> +	.ndo_change_mtu	   =3D vbus_enet_change_mtu,
>>>> +	.ndo_tx_timeout    =3D vbus_enet_timeout,
>>>> +};
>>>
>>> Missing=20
>>> 	.ndo_set_mac_address =3D eth_mac_addr,
>>> 	.ndo_validate_addr   =3D eth_validate_addr,
>>>
>> Ack.
>>
>>> Also, should have change_mtu.
>> note that I do have .ndo_change_mtu.  I assume this is what you are
>> referring to and just missed it.  If there is something else I need
>> there, let me know.
>=20
> If you don't have a change_mtu, then MTU is unlimited.

Is "change_mtu" different from .ndo_change_mtu" on the ndo struct?
That's whats confusing me, as I have the .ndo one already.  Is there
something else I need in addition, or should I be ok as is?

> Can the device handle 64K or larger transfers?

Well, its been tested with 64K GSO packets at least.  I think it could
handle arbitrarily large packets as long as they are paged, but I have
never tried this beyond 64k due to the simple L4 limitations of 64k.

Thanks Stephen,
-Greg


--------------enig0B70D64D9F73FB923974D8FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp3R2oACgkQP5K2CMvXmqHn1ACgjI5YhuvED29ZpAcviHHIiwo6
mg8An38icNKfF9CELsCqPy4DLYEzGEgh
=3ROs
-----END PGP SIGNATURE-----

--------------enig0B70D64D9F73FB923974D8FD--
