Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbYL2Peu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbYL2Peu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYL2Pel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:34:41 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49987 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYL2Pek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:34:40 -0500
Message-ID: <4958EEB6.5020105@novell.com>
Date: Mon, 29 Dec 2008 10:37:26 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu>
In-Reply-To: <20081212114952.GA16976@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig517B7876FCC050C62DE18878"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig517B7876FCC050C62DE18878
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>  =20
>>>   I was able to reproduce your first error (in the previous mail) by =

>>> turning off CONFIG_SMP.  I have folded your fix into my series and=20
>>> got past it.  However, I was not able to reproduce these two new=20
>>> errors.  I was thinking that perhaps something merged improperly=20
>>> between my (older) tip/master and the merge point in cpus4096.  So I =

>>> rebased the series on your latest tip/master as of this morning, but =

>>> it still builds fine for me.  Could you send me the .config that=20
>>> causes this to blow up?  I will get it straightened out for you ASAP.=
 =20
>>> Sorry for the inconvenience.
>>>      =20
>> Could you send a delta fix against cpus4096 for that bug you fixed?
>>    =20
>
> in fact ... i had to temporarily remove your patches because it held=20
> tip/cpus4096 hostage and there were other patches waiting to be queued =
up=20
> there. Latest sched/core is now included in cpus4096, so please resend =

> the series against that tree.
>
> 	Ingo
>  =20

Hey Ingo,
 Just getting back online now, sorry for the delay.  I will look at
getting this series working against cpus4096 as you requested.

-Greg



--------------enig517B7876FCC050C62DE18878
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklY7rYACgkQlOSOBdgZUxltBgCfdl/+a0kFXhmljGXEwIIxihVr
Ev4An05KuPktNEGFzkOP5m1UgnbAPOAI
=Bw17
-----END PGP SIGNATURE-----

--------------enig517B7876FCC050C62DE18878--
