Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYL2L4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYL2L4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYL2L4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:56:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYL2L4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:56:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Mon, 29 Dec 2008 06:56:31 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271557.07003.vapier@gentoo.org> <495699A0.10305@zytor.com>
In-Reply-To: <495699A0.10305@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5381082.IQdzbFilAr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812290656.32827.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5381082.IQdzbFilAr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 16:09:52 H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > ...
> > #ifdef __KERNEL__
> > # define kernel_flock flock
> > #endif
> > struct kernel_flock {
> > ...
>
> FWIW, a long time ago I proposed the __kabi_ prefix for these things; I
> think it is a good thing to make userspace-visible structures stand out
> even in the kernel code itself.
>
> As such, I would suggest *not* adding the #define at all.

the convention based on linux/types.h seems to be to use __kernel_ as the=20
prefix, but it doesnt matter to me whether it's __kabi_ or __kernel_.  i'll=
=20
start doing the latter though in the hopes it'll be less scary ;).
=2Dmike

--nextPart5381082.IQdzbFilAr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWLrwAAoJEEFjO5/oN/WBBToQAM5ol7ufmNIMa8CawSodLST+
QcfW4/gGgpTMfR10Uu7yirZftJefISxPU+WsqJKv2Vykpyj0AALhVNcZT8uPgKfW
kA3eVyx+EG8nT1LKRkkfDcOr5uiiPwuNI6wypdzJLb/SagZ61XB3jS+QHNgLq6DQ
7ByzvpfBQRly2mhi8W/ZMgRw/+fpjM35uVDfTmBF7NQInn+zZkMOYCsRULg3ceIg
ZXtu/wTqQssz9ezaxsP8t7Mf8DeCOVZDNJnY84tGhGzdyLZuMN8MLZoJ7Z6rcuVo
ZaoWzCidKySF8ieyuecMGP1BgH6QiBHLEc/+yGP0CtU1cbrgA9BNhaA3WG/lTDi7
/pXBWR+DCHlZDzXwtDIDRUzIa350Ltdm0cRGKkmwpuPeQJuxNgcyWaISITxIJVVG
yFvZOXUxtpQo8n1BwdYaaj0aHLozxb30+rrYcfhBNGT0flzJE56fqxy0MJYlldFL
EVUV1k4f3cEVfkAgn0oIuPu/yQASmoiBhHGSIlA589LC9HalgQmMdKGskLEZ4SYl
uo+EDc9UKYtQNaC/mEN29IC3Lgxsj/PEHYG6ARV3NQd9Q83l9VET1hWh9YYaO1Qw
njrzDGjaLJFaEJNqpIrzeoIi/1Od7cHjn2GN1+PHxH3LuNwooNfyGxJ+vspyEl1O
TWZt+5ZC6oy7Bz00y4Gw
=T3h5
-----END PGP SIGNATURE-----

--nextPart5381082.IQdzbFilAr--
