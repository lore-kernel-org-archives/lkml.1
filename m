Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbZCXP5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbZCXP5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZCXP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:57:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51932 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZCXP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:57:18 -0400
Message-ID: <49C90366.2000905@novell.com>
Date: Tue, 24 Mar 2009 11:59:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
References: <20090318225137.GA3766@hades.domain.com> <20090323175224.GA3938@hades.domain.com> <20090324140419.GD32043@elte.hu> <49C8FA99.9030503@novell.com> <20090324154130.GC31143@elte.hu>
In-Reply-To: <20090324154130.GC31143@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C972C276C3AE8525686E246"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C972C276C3AE8525686E246
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Ingo Molnar wrote:
>>    =20
>>> * Luis Henriques <henrix@sapo.pt> wrote:
>>>
>>>  =20
>>>      =20
>>>> On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
>>>>    =20
>>>>        =20
>>>>> Since they are used on in statistics and are always set to zero, th=
e following
>>>>> fields from struct rq have been removed: yld_exp_empty, yld_act_emp=
ty and
>>>>> yld_both_empty.
>>>>>
>>>>> Both Sched Debug and SCHEDSTAT_VERSION versions has also been incre=
mented since
>>>>> ABIs have been changed.
>>>>>
>>>>>      =20
>>>>>          =20
>>>> Hi Ingo,
>>>>
>>>> Sorry to bother you but I can not find this patch in -tip.  Just=20
>>>> would like to confirm with you that it was NACK'ed or you just=20
>>>> forgot to merge it to the tree.
>>>>    =20
>>>>        =20
>>> Was held up by the schedstat tool discussions. Please resend the=20
>>> patch with a link to the updated tool in the commit log perhaps (if=20
>>> such a link exists), and with Gregory's ack in place.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>>  =20
>>>      =20
>> Hi Ingo,
>>   I was waiting to merge the tool patch until I was sure this would be=

>> your blessed v15 of the ABI.  If you are comfy with the kernel patch b=
ut
>> want the tool updated before the kernel, I can do that, no problem.  T=
he
>> only thing that I ask is that if for some reason this kernel patch
>> doesn't make it in, please require any future patches that change this=

>> ABI to be versioned > 15 ;)
>>    =20
>
> How about moving schedstat to Documentation/sched/schedstat.c or so?=20
> It's small and trivial enough, and that way changes would go hand in=20
> hand with the app.
>  =20
Oh, I misunderstood.  The tool patch I was referencing is for my
schedtop tool that is in a separate tree and written in C++.   In
retrospect, you probably don't care about the relative state of my tool
coincident with the kernel side change, then.  I agree that this other
schedstat tool should probably be in-tree and patched at the same time
as Luis' kernel patch.

FWIW: I have no problem with schedtop.cc going into the kernel as well
if that is what you would like, but I figured I would be burned at the
stake for suggestion such heresy as C++ in the tree ;)

-Greg


--------------enig1C972C276C3AE8525686E246
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknJA2YACgkQlOSOBdgZUxnP+ACfd5br/sLxh7xVoZ2+lUc8Slu6
exYAnjRacCRdOhvIOggKsowwdlxYwx6w
=O3i3
-----END PGP SIGNATURE-----

--------------enig1C972C276C3AE8525686E246--
