Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYJVOBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYJVOBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYJVOBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:01:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59101 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYJVOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:01:14 -0400
Message-ID: <48FF3321.4060809@novell.com>
Date: Wed, 22 Oct 2008 10:05:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: deep power-saving states
References: <48FF2DDC.5010600@gmail.com> <20081022064738.05818670@infradead.org>
In-Reply-To: <20081022064738.05818670@infradead.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA77803111A387927C48CFEB5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA77803111A387927C48CFEB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven wrote:
> On Wed, 22 Oct 2008 09:42:52 -0400
> Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:
>
>  =20
>> What I was thinking is that a simple mechanism to quantify the
>> power-state penalty would be to add those states as priority levels in=

>> the cpupri namespace.  E.g. We could substitute IDLE-RUNNING for IDLE,=

>> and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn, OTHER, RT1, .. RT99.  This
>> means the scheduler would favor waking an IDLE-RUNNING core over an
>> IDLE-PS1-PSn, etc.  The question in my mind is: can the power-states
>> be determined in a static fashion such that we know what value to
>> quantify the idle state before we enter it?  Or is it more dynamic
>> (e.g. the longer it is in an MWAIT, the deeper the sleep gets).
>>    =20
>
> it's a little dynamic, but just assuming the worst will be a very good
> approximation of reality. And we know what we're getting into in that
> sense.
>  =20

Ok, but if we just assume the worst case always, how do I differentiate
between, say, IDLE-RUNNING and IDLE-PSn?  If I assign them all to
IDLE-PSn apriori its no better than the basic single IDLE state we
support today.  Or am I misunderstanding you?

-Greg



--------------enigA77803111A387927C48CFEB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkj/MyEACgkQlOSOBdgZUxnZ4gCdHgNvHPsY1xOU38xBljVhEM6C
qQAAnjGP4GjAd7nYCEf3VTnnPhuxCWMN
=1PF+
-----END PGP SIGNATURE-----

--------------enigA77803111A387927C48CFEB5--
