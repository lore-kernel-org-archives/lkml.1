Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZANNS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZANNS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZANNSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:18:48 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:36007 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbZANNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:18:47 -0500
Message-ID: <496DE6E4.1010209@novell.com>
Date: Wed, 14 Jan 2009 08:21:40 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, rostedt@home.goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: fix build error in kernel/sched_rt.c when	RT_GROUP_SCHED
 && !SMP
References: <20090113014333.GA23448@elte.hu> <20090113023345.32433.28954.stgit@dev.haskins.net> <20090114080111.GC18649@elte.hu> <1231930476.7141.27.camel@twins> <20090114110356.GK2913@elte.hu>
In-Reply-To: <20090114110356.GK2913@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig22F9A9CDD938954DF18877A8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig22F9A9CDD938954DF18877A8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>  =20
>> On Wed, 2009-01-14 at 09:01 +0100, Ingo Molnar wrote:
>>    =20
>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>
>>>      =20
>>>> +#define dec_rt_group(rt_se, rt_rq) do { } while (0)
>>>>        =20
>>> Please dont _ever_ introduce new CPP macros into core kernel code, an=
d if=20
>>> you see existing once, please fix them to be proper C inline function=
s.=20
>>> (there's a few other new macros in your patchset)
>>>      =20
>> Generally good advice, and certainly doable in this case. But in some =

>> very rare occasions I've had to use CPP in order to avoid silly header=
=20
>> dependency hell -- I think we should add comments in such cases as to =

>> why we use CPP.
>>    =20
>
> yeah - that's why i qualified it with 'core kernel code', not 'headers'=
=2E=20
>
> (But even in the dependency spaghetti case the right solution is to cle=
an=20
> up the header dependencies. It's just very hard in most cases due to mo=
st=20
> folks running on x86 and there being 20+ other architectures they canno=
t=20
> really test. So the dependency hell tends to grow not shrink. )
>
>  =20

Hey guys,
  Sorry, wasn't aware of that rule.  Ill spin a v3 and send it out later
today.

-Greg


--------------enig22F9A9CDD938954DF18877A8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklt5uQACgkQlOSOBdgZUxldUACgi/oBEIY8gDAs9Nq3oSZvKRky
cbIAn10OjOnQ3WC8Ba4iaMgdkZUqF0jm
=NhqT
-----END PGP SIGNATURE-----

--------------enig22F9A9CDD938954DF18877A8--
