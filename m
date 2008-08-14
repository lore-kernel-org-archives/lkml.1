Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYHNTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYHNTBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHNTBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:01:38 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47553 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYHNTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:01:37 -0400
Message-ID: <48A48086.3010603@novell.com>
Date: Thu, 14 Aug 2008 14:59:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A465BA.5050406@goop.org> <48A468F5.4050308@zytor.com> <20080814174612.GB4697@Krystal> <48A4700F.6030806@goop.org> <20080814175523.GC4697@Krystal>
In-Reply-To: <20080814175523.GC4697@Krystal>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig145659043AE931B7E708CB0D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig145659043AE931B7E708CB0D
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>  =20
>> Mathieu Desnoyers wrote:
>>    =20
>>> Here are the specs. It's a brand new 64bits dual quad-core (Christmas=
 in
>>> August) :-) None of the specs seems to talk about neither Core2 or
>>> Pentium 4 though. Those appellations seems to hold for desktop
>>> processors, not server processors...
>>>  =20
>>>      =20
>> Is it a Dell thingy?  Turns out my main test box has exactly the same =

>> processor.
>>
>>    J
>>    =20
>
> Nope, it's a custom-made machine from a company in the Montreal area. I=
t
> has a Supermicro X7DAL-E motherboard and, well, I got 16GB of ram in it=
=2E
> Pretty useful to take large traces.
>
> Mathieu
>
>
>  =20

FWIW, I think its a Harpertown:

http://processorfinder.intel.com/details.aspx?sSpec=3DSLAP2

-Greg


--------------enig145659043AE931B7E708CB0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkikgIcACgkQlOSOBdgZUxlYzgCeIMS/sQO3cVv7dsRNPCKpdbF3
vSMAnAzIQ3PZstR4vqP0y9O3tTh37N4z
=phXK
-----END PGP SIGNATURE-----

--------------enig145659043AE931B7E708CB0D--
