Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYIUTOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYIUTOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIUTOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:14:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYIUTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:14:21 -0400
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
	restart.
From: Johannes Berg <johannes@sipsolutions.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
In-Reply-To: <20080921190050.GA20484@2ka.mipt.ru> (sfid-20080921_210242_482049_43D40C50)
References: <20080921172316.GA6306@2ka.mipt.ru>
	 <20080921110422.1d010b96@infradead.org>
	 <20080921182835.GA11473@2ka.mipt.ru>
	 <20080921113513.16677c4e@infradead.org>
	 <20080921190050.GA20484@2ka.mipt.ru> (sfid-20080921_210242_482049_43D40C50)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P4pWs/jhFbewJryBGqCD"
Date: Sun, 21 Sep 2008 21:14:04 +0200
Message-Id: <1222024444.3023.53.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P4pWs/jhFbewJryBGqCD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-21 at 23:00 +0400, Evgeniy Polyakov wrote:

> Do you want me to implement ipw2100 driver as a big work structure
> which will run ipw2100_init()/wait/ipw2100_exit() in a loop?
> And that will be the fix suggested by Intel? That would explain a lot.

I think what Arjan is saying is that it would be better to put pressure
on the responsible folks (I don't think Arjan is anywhere near them at
all) if you'd put in a WARN_ON() for this error and that would make the
top entry on kerneloops.org all the time... And additionally put in a
workaround for yourself for now.

And can we keep the flames off this list please? That comment from Wei
Weng was absolutely uncalled for, and inciting a flamewar (as you have
already blogged) was not really productive either.

johannes

--=-P4pWs/jhFbewJryBGqCD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1pz3AAoJEKVg1VMiehFYFTUQAMXGPaS6Ec7oPwiOp2SGm2Om
o8hTLtj+ZpIkBVdVLrm+gukxsEh3NENUdBHWaRuA5BKeOL8yXzTAFoBxGp6RhJfU
4wLIY0ju3BQIpnau6a1LIe5PHaQXKUs/B70zfrY7WC+/bEbUCB5cBYklhzIVCtih
PjSbtE4Ljrv4Mb8AzNVNm6ZKvRZ57HA0gycWirziD5LbbbssIvupIJ3mXA5jtmJ6
s8ljlkcp2UXT+jTDaFHUeBhzNVYnJQ+M+F2E0ZMW9/v/S5an+dq5zVFqQ7f/Icp5
Pr6W6ZwGjfx9w+BQuvKMKtT+8UeEuRzAcSFi23x1BVtV776/ZoH9J5t6SnhXZpJ9
hNCxruP8vdlP9bp6izJlrSNA3qEDhnxwZQqbr1h6e65uzcwNO/d9qTXgzpu0MDpp
9WX6j6A5VmHTQ2R+YGRXRSRiSKsXa5ADLqcQncMJs7jIgfoHHtXGfleUhy/3JTU4
iD9rBXh5sHoviIzmtfaj72JGeflPjDOvOWdEBTfL3KuVfVcYN4PaAGAT96yXUwpp
SB7129nIDLDwbu/mm+7TkIHCRK2q/mvz4e499uiLt6eIhYmopXKmS/+KK7SLRDi1
nqu3ztZhSJrKceHpjMlgaadVRv3oTi3xADwhsm6sW3xuCko8uJs33jS3m7oN4PuS
1U9xyn52TP88ON++vREd
=i2O6
-----END PGP SIGNATURE-----

--=-P4pWs/jhFbewJryBGqCD--

