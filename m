Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZA0SNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZA0SNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZA0SNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:13:32 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:55782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZA0SNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:13:32 -0500
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090127134128.GA24965@elte.hu>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-izPwRgHpAwjVa4NfiddF"
Date: Tue, 27 Jan 2009 19:12:47 +0100
Message-Id: <1233079967.4755.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-izPwRgHpAwjVa4NfiddF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 14:41 +0100, Ingo Molnar wrote:
> -tip testing found this build failure with your patch:
>=20
>  arch/x86/kernel/hpet.c:631: error: too few arguments to function =E2=80=
=98init_timer_on_stack_key=E2=80=99

#define init_timer_on_stack(timer)\
        init_timer_on_stack_key((timer)), NULL, NULL)

needs to be

#define init_timer_on_stack(timer)\
        init_timer_on_stack_key((timer), NULL, NULL)

johannes

--=-izPwRgHpAwjVa4NfiddF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJf06bAAoJEKVg1VMiehFYxF0QAKjkNWR/2ib3GPwrZ+cSpxD7
MzJ+5Cu2H/SdvCKybTWDpIA/tPFRNirP5jAfb6sijdqu0Zz88O+Lv+psa7Z/hgas
Lk7QPH0xPY1csJ8DzEIC5BUC8cUxMDhu6d8EIZ9dgakYMLW5E6PyyYErQ/oepXza
xH385fEJHsc9huT7VTW0cGUDe2Mi7AVME72/4CFXA9xtuuEK/kX4NJYZhO7EV+Dk
ozVSLhHePotNUO3TxEzI+P4QwU77sy2kJbnFK6YF0HwFpBKnoJ9KcBat0kgOhX78
eMDSn2HWFKNKOK65LQo7pmUj4vQanqJzuAIrWn81ekUb8/YzkfWillNRcu2jUkuW
Y7Wdj7acRkkh1lo7V2AiCUDt1vmDLSpognoef4YDDEqUeBJn+BcEWFRdhtUi5P93
0lUGTle+hvxWXeWVELpdoP21hcC53toWKO5nw0cmucZ+uXvRXPCaS7msBIDqgawt
LfrZxnpSBG3Zf/OEwsGdNI6MSk3TgWKBgNk6P5UdFFULEjdf1HMfMhk9DJXobF53
rAKN9ugHHvQGx0jmEgZrCxBAI8hUyAzyz4q6x0Sq6wZuxDdAau4DKHyIzt0ChU2Q
olxSLwxA8FlVubZDEOOkg1yq4Dun6RolOv2/nGgFBGst7emRUA5i01+qfr1O0/98
7NJ4iH5G4NUtIgj6whYa
=qRvi
-----END PGP SIGNATURE-----

--=-izPwRgHpAwjVa4NfiddF--

