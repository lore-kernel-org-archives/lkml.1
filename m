Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZIJTzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZIJTzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZIJTzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:55:10 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46662 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZIJTzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:55:09 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 15:55:09 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Thu, 10 Sep 2009 21:45:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Con Kolivas <kernel@kolivas.org>
References: <20090906205952.GA6516@elte.hu> <4AA76FD2.1050103@arcor.de> <1252487869.7746.181.camel@twins> (sfid-20090909_111953_200988_A02CB5A6)
In-Reply-To: <1252487869.7746.181.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3556249.JiEUj4pTiB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909102145.53332.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3556249.JiEUj4pTiB
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > Thank you for mentioning min_granularity.  After:
> >
> >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
>=20
> You might also want to do:
>=20
>      echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
>=20
> That affects when a newly woken task will preempt an already running
> task.

Heh that scheduler thing again... and unfortunately Col appearing to feel=20
hurt while I am think that Ingo is honest on his offer on collaboration...

While it makes fun playing with that numbers and indeed experiencing=20
subjectively a more fluid deskopt how about just a

echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload

Or to say it in other words: The Linux kernel should not require me to=20
fine-tune three or more values to have the scheduler act in a way that=20
matches my workload.

I am willing to test stuff on my work thinkpad and my Amarok thinkpad in=20
order to help improving with that.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3556249.JiEUj4pTiB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqpV2sACgkQmRvqrKWZhMf1xgCfT/nuF5hLfFXLXNydZcrZEPWp
AXcAn0rCBasqT9KolgBeiYOc4+mfcq7I
=c/UZ
-----END PGP SIGNATURE-----

--nextPart3556249.JiEUj4pTiB--
