Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZA0Sd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZA0Sd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZA0Sds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:33:48 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:53261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZA0Sdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:33:47 -0500
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233081027.10992.21.camel@laptop>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b1YBuETGJ1NPi6u+YBjQ"
Date: Tue, 27 Jan 2009 19:33:07 +0100
Message-Id: <1233081187.4455.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b1YBuETGJ1NPi6u+YBjQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 19:30 +0100, Peter Zijlstra wrote:
> On Tue, 2009-01-27 at 19:06 +0100, Johannes Berg wrote:
> > On Tue, 2009-01-27 at 14:41 +0100, Ingo Molnar wrote:
> > > -tip testing found this build failure with your patch:
> > >=20
> > >  arch/x86/kernel/hpet.c:631: error: too few arguments to function =E2=
=80=98init_timer_on_stack_key=E2=80=99
> >=20
> > Odd, I'll look into this.
> >=20
> > Meanwhile, I'd appreciate comments on
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D12552
>=20
> Seems valid to me, the workaround in run_workqueue() seems applicable
> here as well.

Alright, will fix.

johannes

--=-b1YBuETGJ1NPi6u+YBjQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJf1NhAAoJEKVg1VMiehFYUPgP/RjrmOMlN/PuYSft62z4QwFq
HUqcKl+V5qXK+r/2ToAzAQXmtvc+qwn46y26KCa5NRve4G3sy7KJ7fQYFiUpeQ6w
D5xXYz6qAZ2eGwXScodu+c/9sIh1F/KBAZJbMgMBYdfgH3TqIhGaEyzVemDA0/wq
zTWnlG6eeLNWQh934qPbR0deVbcAuGVGS8IDyrHfdre2WhQll929ZG9vb26D+LN4
zSlopneDyv0vz5aAiMKqCNGqyHDqfmNF70cN6p2neDJM+5vdmpeLdO78osZUh0+J
u7ghxEe438tMgrtgHmuBi5IZ9q+fq1/bgKyFqOV8nFVbTReWV2CWlaVpPKls0AJI
/h2MVasYwx44ysI3ag0dU8cwSddHohtdUVnl8Mt4ThufiOmLhv4EYFEwMoYexx3p
ZsXQTGhi2hZNBF16XG4QyO8VL3y60bkazr6iCU0EiDT+wjugvy0Np/gCIxaBzEW3
yeWRqhwJBlu9+NfnK0nANG4QUCqhbR2hnu4MbN7qQM/n46WuhrROjJ2RQbj3Dx8P
MoX5lb6R8RqrBvdTDagutrJxHPUjJ/GubqYQujMpqpEHEagUA/w1Zflo5iKl91c5
guSFboRJFJ7yioWp/+YREaLirsTPi7OADl4noH1vyVlRU/Hrq+l4IqOYKrLb83VU
U07NRevcwL16rMURABkB
=P3zz
-----END PGP SIGNATURE-----

--=-b1YBuETGJ1NPi6u+YBjQ--

