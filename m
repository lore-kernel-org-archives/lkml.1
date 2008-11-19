Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYKSV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYKSV1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYKSV0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:26:20 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:48502 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYKSV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:26:17 -0500
Message-ID: <49248560.1020501@novell.com>
Date: Wed, 19 Nov 2008 16:30:08 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Max Krasnyansky <maxk@qualcomm.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <20081119203340.GC2383@sgi.com>
In-Reply-To: <20081119203340.GC2383@sgi.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig78BE9FC0641A7C88E3FF2FAF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig78BE9FC0641A7C88E3FF2FAF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dimitri Sivanich wrote:
> On Wed, Nov 19, 2008 at 03:25:15PM -0500, Gregory Haskins wrote:
>  =20
>> It sounds like the problem with my code is that "null sched domain"
>> translates into "default root-domain" which is understandably unexpect=
ed
>> by Dimitri (and myself).  Really I intended root-domains to become
>> associated with each exclusive/disjoint cpuset that is created.  In a
>> way, non-balanced/isolated cpus could be modeled as an exclusive cpuse=
t
>> with one member, but that is somewhat beyond the scope of the
>>    =20
>
> Actually, at one time, that is how things were setup.  Setting the
> cpu_exclusive bit on a single cpu cpuset would isolate that cpu from
> load balancing.
>  =20
Do you know if this was pre or post the root-domain code?  Here is a
reference to the commit:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmit;h=3D57d885fea0da0e9541d7730a9e1dcf734981a173

A bisection that shows when this last worked for you would be very
appreciated if you have the time, Dimitri.

Regards,
-Greg



--------------enig78BE9FC0641A7C88E3FF2FAF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkkhWAACgkQlOSOBdgZUxmbkgCghFJthdhcF4AiuJ7JzqjNYLdA
YZ4AnA1M0m2Kd2/7Pmux8M7edxKyzKB+
=PxmA
-----END PGP SIGNATURE-----

--------------enig78BE9FC0641A7C88E3FF2FAF--
