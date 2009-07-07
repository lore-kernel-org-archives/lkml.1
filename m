Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZGGL1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZGGL1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZGGL1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:27:01 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZGGL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:27:00 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200907071258.33579.rjw@sisk.pl>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <bXZeuxPQAWE.A.ZFB.BCpUKB@chimera> <1246925538.4652.8.camel@johannes.local>
	 <200907071258.33579.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CYAa0MFFR9EgW8FJ+MNw"
Date: Tue, 07 Jul 2009 13:27:01 +0200
Message-Id: <1246966021.4755.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CYAa0MFFR9EgW8FJ+MNw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 12:58 +0200, Rafael J. Wysocki wrote:

> Thanks for the update.
>=20
> Last time I remember you managed to collect some ftrace output from the f=
ailing
> case, but they didn't reveal anything directly.
>=20
> We know, however, that is [suspend|resume]_device_irqs() in
> driver/base/power/main.c are disabled, the issue doesn't show up.
>=20
> Is that correct?

I'm not sure -- did we verify that somehow? I was running with some
trial patch from you for a long time but it had no apparent effect.

johannes

--=-CYAa0MFFR9EgW8FJ+MNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUzEBAAoJEODzc/N7+Qma/SsP/1poqPzQzwXnYDtr0VMfqnq6
3OPwbCe5VPzYpuaIurqQrcDAteE+yuNmxZqk5G1zmdhO9YP1gtmtjYINYQEmCOv/
hLfvgwVRKPseXSZ7aIr08eA4yg/l2UvB/hjOIrVXTEX3ynW5f9ieYmz+C+ElHyZl
cZQZUF8nnH6BjHtpXobO5oL+N/DK2DE5SpSKX/Mxc6EKQ5zcqDPC/gL6IjT1Sr+g
gxdgvS6isaza8IqCF7cEYzdz32+FflFDAn4gzSYiU68Rr+ehyMrKku2h7PvEll4y
CK3tAecXGvUB1RRCk1hi7EqQU0r2/NxGlw3TZan33d6p/nPq7wyrggOehHAnwTxS
0b1qMD10XQp0W5nc3sXpcxIZysto25XL8FXaqscXoYJI+0CBGDDZ+gLoMyy6SKJB
vBqI7oPiOyvZLJaFB1Z4JyNZyuMZUVv7jWxaJv2bSvClFVrvxPBiA9UURm5fzWTu
6RnezzcN0VRWPqS7NquIrVK9RAcEa/AGY3W+JXiCS0b6/asVFlcUQ+iPsjpLF45q
9wxZ0pdliCx/ybyQs9FSLCSM8Owz6mL2witDr1VZIiuLdP/IqsamyE6WI1gTY3K3
HKKTBPVbsiGIad6HLqAU+FUkIwbkx40pt6eScvuzr649IUojbUFgRI/okCFenRnD
0pti8GQ5NYIfmvYVo4OW
=Mq+N
-----END PGP SIGNATURE-----

--=-CYAa0MFFR9EgW8FJ+MNw--

