Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYH0MCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYH0MCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYH0MC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:02:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36874 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYH0MC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:02:26 -0400
Message-ID: <48B541C3.1090901@novell.com>
Date: Wed, 27 Aug 2008 08:00:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@suse.de>, mingo@elte.hu, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, Russell King <rmk+lkml@arm.linux.org.uk>,
       ralf@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
References: <20080826173131.16413.17862.stgit@dev.haskins.net>	 <20080826173500.16413.40514.stgit@dev.haskins.net>	 <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de>	 <1219833668.6462.72.camel@twins>  <20080827105615.GB5818@wotan.suse.de> <1219835224.6462.81.camel@twins>
In-Reply-To: <1219835224.6462.81.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFB6ECC11701E4AF6000D3CA0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFB6ECC11701E4AF6000D3CA0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Wed, 2008-08-27 at 12:56 +0200, Nick Piggin wrote:
>
>  =20
>> BTW. I wonder about other architectures that are of interest to -rt? L=
ike
>> mips or arm perhaps... Any plans to implement ticket locks on those, o=
r
>> do they not tend to be used in SMP configurations on -rt yte?
>>    =20
>
> I think both are starting to show more and more SMP machines, so yes,
> eventually we'll want ticket locks for them too.
>
> That said, I'm not aware of anyone working on it - I suppose we could
> poke the regular arch maintainers.. Ralf, Russell ?
>
>  =20
As an aside:  I have an implementation of C-based ticket lock
replacements for raw_spinlock_t that I could post.  I never posted them
because I mostly care about x86 and Nick's solution is superior there
since its hand-tuned asm.  But mine could be used in places that have
not yet written arch support but need FIFO.  I basically have it as a
config option to enable "generic fifo spinlocks" or something like that.

-Greg


--------------enigFB6ECC11701E4AF6000D3CA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1QcMACgkQlOSOBdgZUxk2ZQCeMrc93DQBBS6zcAX8OODNsWIJ
Ah4Anjz8/a7S9yLWWeN15toq525hS0QQ
=zTo3
-----END PGP SIGNATURE-----

--------------enigFB6ECC11701E4AF6000D3CA0--
