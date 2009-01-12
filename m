Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZALPCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZALPCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZALPC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:02:28 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:33519 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZALPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:02:27 -0500
Message-ID: <496B5C2C.2050908@novell.com>
Date: Mon, 12 Jan 2009 10:05:16 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
References: <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu> <4958EEB6.5020105@novell.com> <49591331.9080403@novell.com> <20090111040121.GD28520@elte.hu> <20090111095325.GA32409@elte.hu> <496B5789.9040004@novell.com> <20090112144548.GA14016@elte.hu>
In-Reply-To: <20090112144548.GA14016@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig918A44D22A7FA6AA91034AF6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig918A44D22A7FA6AA91034AF6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Ingo Molnar wrote:
>>    =20
>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>  =20
>>>      =20
>>>>> Hi Ingo,
>>>>>   I have rebased the series against tip/cpus4096 as of today.  I
>>>>> built/boot this kernel for both SMP/UP on a 4-way x86_64 box, and t=
hey
>>>>> look sane.  Let me know if they still look broken to you.
>>>>>      =20
>>>>>          =20
>>> yes, i still get build failures:
>>>
>>> kernel/sched_rt.c:574: error: 'struct rq' has no member named 'cpu'
>>> kernel/sched_rt.c:619: error: 'rq' undeclared (first use in this func=
tion)
>>> kernel/sched_rt.c:619: error: (Each undeclared identifier is reported=
 only once
>>> kernel/sched_rt.c:619: error: for each function it appears in.)
>>> kernel/sched_rt.c:667: error: 'rq' undeclared (first use in this func=
tion)
>>>
>>> so i've excluded tip/sched/rt from tip/master for now.
>>>
>>> 	Ingo
>>>  =20
>>>      =20
>> Hey Ingo,
>>   Sorry for all these problems.  I am not sure what is happening since=

>> it seems to build fine for me on this end.
>>
>> I just pulled down tip/sched/rt (sha=20
>> 0a6d4e1dc9154c4376358663d74060d1e33d203e) and built for my x86_64=20
>> machine with both SMP and UP (configs attached).  They both completed =

>> without errors.  Could you send me the config you are having trouble=20
>> with?
>>    =20
>
> dont have it anymore - but you can look at the build error itself and=20
> figure out what config options it needs to trigger such problems=20
Yes, of course.  At least one of us has engaged their brains this AM ;)

Thanks.  Fix forthcoming.

-Greg



--------------enig918A44D22A7FA6AA91034AF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklrXCwACgkQlOSOBdgZUxk3bgCggKX+XHogPdCK8bKoE6vqnqUY
Ms8An1jDUfzhmv6f6FTphv1DugEVJMzk
=Z27l
-----END PGP SIGNATURE-----

--------------enig918A44D22A7FA6AA91034AF6--
