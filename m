Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYANKft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYANKft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYANKfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:35:39 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:43369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYANKfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:35:38 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1200302644.7415.6.camel@twins>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mnnig6DVm2aT6H9ol1c9"
Date: Mon, 14 Jan 2008 11:35:02 +0100
Message-Id: <1200306902.5887.39.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mnnig6DVm2aT6H9ol1c9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > When I "halt -p", lockdep warnings triggered as following (hand copy):
> >=20
> > WARNING : at kernel/lockdep.c: 700 lookup_lock_class()
> >=20
> > <snip>
> > lock_acquire
> > cleanup_workqueue_thread
> > workqueue_cpu_callback
> > notifier_call_chain
> > __raw_notifier_call_chain
> > raw_notifier_call_chain
> > __cpu_down
> > disable_nonboot_cpus
> > kernel_power_off
> > sys_reboot
> > <snip>
>=20
> My first guess would be a __create_workqueue_key() where a key is
> re-used with a different workqueue name.

Hm, can you elaborate how you got there from the trace above? I don't
think I'm following.

johannes

--=-Mnnig6DVm2aT6H9ol1c9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4s61aVg1VMiehFYAQLzHhAAhWs3JlJneVzjK04Cxn0usN5WkR8fHyWG
bHgzfa1svCVycnkR5f+TJVIkCDYYYaJFuSWrt3+EwYPGI3M3k/NYSwWMFG32huTN
nQd5x85VYLjtXa+HF7bbYoQSEqcu7oEBZRfyDiy2B4Ap+pvKgZFD2zmm7gyKhpHh
arqRFNbZiXUEb3mssZR5VORW2sQKxKvrgQnxmRGpKDPDkVT/iUubHEieK7LE/usR
NX6kQXAx7+laB8KRHRSe2siZ1hnDoQkS6f5Mmy5hViTKTag3b3dubANRv+Io/frw
UweEBVFue0Y/lsR462CZp9osxn4cCof/PIL9JvyzO8qzGw4Hu7fYfF+e0VJ7e0G3
OHEGkujdw/ByQGAiKJHfD40yEnICymexEmwXewh2s6ri7F4S2zb/FRI2Y6kF6Dz+
yTEY0As4MDb0Rs3rLyG6benQK0AQ/iwLSAJogCz6GBsXP/yM/Kj/C0h4RKMZbkns
4W9PXbKEeGLcDauEFWnw7iWzYvBl6zb9FuSHzUWSDPvrQuCs8/mCd70Ws4QS40L1
Cl66h31iSvgZYjo+HYGPuiyz0BAalnGVmSUFc2UntmKKBx1Co1j9AOTBgMQzOjjp
Tu+JWsStpAzjz0CWMsOVtlP9RhtSyZy5w25AnouBFQDBbsp0HiqhdJ1MoP156qqC
Ns5pI1fsblA=
=banZ
-----END PGP SIGNATURE-----

--=-Mnnig6DVm2aT6H9ol1c9--

