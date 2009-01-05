Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZAES4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZAES4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZAES4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:56:38 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40834 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZAES4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:56:38 -0500
Message-ID: <49625894.3090706@novell.com>
Date: Mon, 05 Jan 2009 13:59:32 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>
Subject: Re: 2.6.27.8 scheduler bug - threads not being scheduled for long
 periods
References: <20090105175641.GA17055@sgi.com> <49625519.4050902@novell.com> <20090105185111.GA18084@sgi.com>
In-Reply-To: <20090105185111.GA18084@sgi.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig917924AC7E1705BDB96C250A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig917924AC7E1705BDB96C250A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dimitri Sivanich wrote:
> Hi Greg,
>
> On Mon, Jan 05, 2009 at 01:44:41PM -0500, Gregory Haskins wrote:
>  =20
>> Dimitri Sivanich wrote:
>>    =20
>>> I'm wondering if anyone else has run into this problem, and whether t=
hey've
>>> found a resolution for it?
>>>
>>>  =20
>>>      =20
>> Hi Dimitri,
>>   I have observed similar problems on my opensuse 11.0 box (2.6.25
>> based) when doing kernel builds.  Often times other apps will get
>> starved (like firefox, etc).  I was talking to peterz about it and he
>> pointed me at a commit that went into 28-rcx that fixes this (the sha
>> escapes me at the moment).  I've been meaning to pull the patch into o=
ur
>> 2.6.25 and 2.6.27 trees to verify if it fixes it, but I have fairly hi=
gh
>> confidence it will.  Perhaps Peter can point you at the same patch and=

>> you can give it a whirl.  For the time being, can you see if 28 is fix=
ed?
>>
>>    =20
>
> 2.6.28 appears to be a little bit worse, actually:
>  =20

Ugg...ok, well thanks for verifying.  I will defer to Peter and Ingo on
this one.

Please keep me in the loop on any new findings here, as the problem
(assuming its the same bug) has been annoying me for months (but
obviously not enough for me to do something about it ;)

-Greg



--------------enig917924AC7E1705BDB96C250A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkliWJQACgkQlOSOBdgZUxm3nQCgh4S2iRHgJy4H/3C+QzZ8guxM
u4MAnAtJcav+zbPKrHDLIZLc2TD61/tZ
=Fjwp
-----END PGP SIGNATURE-----

--------------enig917924AC7E1705BDB96C250A--
