Return-Path: <linux-kernel-owner+w=401wt.eu-S935161AbZAPOAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935161AbZAPOAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934669AbZAPN7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:59:25 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:55510 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934649AbZAPN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:59:22 -0500
Message-ID: <4970936E.4020403@novell.com>
Date: Fri, 16 Jan 2009 09:02:22 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, rostedt@home.goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] fixes for tip/sched/rt
References: <496DE6E4.1010209@novell.com>	 <20090114144317.11627.69111.stgit@dev.haskins.net>	 <20090115123051.GA21096@elte.hu>  <20090116133530.GA23674@elte.hu> <1232113600.14073.25.camel@laptop>
In-Reply-To: <1232113600.14073.25.camel@laptop>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5E8238457CE9CDBA3FF179FD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5E8238457CE9CDBA3FF179FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Fri, 2009-01-16 at 14:35 +0100, Ingo Molnar wrote:
>  =20
>> here's a new build failure with tip/sched/rt:
>>
>>   LD      .tmp_vmlinux1
>> kernel/built-in.o: In function `set_curr_task_rt':
>> sched.c:(.text+0x3675): undefined reference to `plist_del'
>> kernel/built-in.o: In function `pick_next_task_rt':
>> sched.c:(.text+0x37ce): undefined reference to `plist_del'
>> kernel/built-in.o: In function `enqueue_pushable_task':
>> sched.c:(.text+0x381c): undefined reference to `plist_del'
>>    =20
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 6504ca6..3e66d41 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -995,7 +995,6 @@ config SLABINFO
> =20
>  config RT_MUTEXES
>  	boolean
> -	select PLIST
>  =20

<snip>

Thanks, Peter!

-Greg



--------------enig5E8238457CE9CDBA3FF179FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklwk28ACgkQlOSOBdgZUxl9xwCdFuGXDP0bEkX25lJgi3fTWwH3
UbUAn1Ui8RD37ggQlnAh3BJoDRkNLEcN
=GP+Z
-----END PGP SIGNATURE-----

--------------enig5E8238457CE9CDBA3FF179FD--
