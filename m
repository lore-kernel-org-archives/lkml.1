Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZCXPUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZCXPUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZCXPTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:19:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41087 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZCXPTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:19:42 -0400
Message-ID: <49C8FA99.9030503@novell.com>
Date: Tue, 24 Mar 2009 11:22:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
References: <20090318225137.GA3766@hades.domain.com> <20090323175224.GA3938@hades.domain.com> <20090324140419.GD32043@elte.hu>
In-Reply-To: <20090324140419.GD32043@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig98C887835BF8B5120EDDA9D3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig98C887835BF8B5120EDDA9D3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Luis Henriques <henrix@sapo.pt> wrote:
>
>  =20
>> On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
>>    =20
>>> Since they are used on in statistics and are always set to zero, the =
following
>>> fields from struct rq have been removed: yld_exp_empty, yld_act_empty=
 and
>>> yld_both_empty.
>>>
>>> Both Sched Debug and SCHEDSTAT_VERSION versions has also been increme=
nted since
>>> ABIs have been changed.
>>>
>>>      =20
>> Hi Ingo,
>>
>> Sorry to bother you but I can not find this patch in -tip.  Just=20
>> would like to confirm with you that it was NACK'ed or you just=20
>> forgot to merge it to the tree.
>>    =20
>
> Was held up by the schedstat tool discussions. Please resend the=20
> patch with a link to the updated tool in the commit log perhaps (if=20
> such a link exists), and with Gregory's ack in place.
>
> Thanks,
>
> 	Ingo
>  =20
Hi Ingo,
  I was waiting to merge the tool patch until I was sure this would be
your blessed v15 of the ABI.  If you are comfy with the kernel patch but
want the tool updated before the kernel, I can do that, no problem.  The
only thing that I ask is that if for some reason this kernel patch
doesn't make it in, please require any future patches that change this
ABI to be versioned > 15 ;)

Thanks!
-Greg


--------------enig98C887835BF8B5120EDDA9D3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknI+pkACgkQlOSOBdgZUxmiqACfbZdQSilvsPO7wOcyNMdU7ha4
SH0AoIKPetvKKGY2GgFI1okrQ2QlzuJR
=EC4I
-----END PGP SIGNATURE-----

--------------enig98C887835BF8B5120EDDA9D3--
