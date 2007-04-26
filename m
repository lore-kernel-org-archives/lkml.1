Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXDZLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXDZLbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXDZLbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:31:50 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXDZLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:31:50 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070426112641.GS17387@elf.ucw.cz>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <1177582633.6814.29.camel@johannes.berg>
	 <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz>
	 <1177585897.6814.49.camel@johannes.berg>
	 <20070426111645.GR17387@elf.ucw.cz>
	 <1177586850.6814.52.camel@johannes.berg>
	 <20070426112641.GS17387@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Kg1mehxX2cXbNaaw7trB"
Date: Thu, 26 Apr 2007 13:35:07 +0200
Message-Id: <1177587308.6814.57.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Kg1mehxX2cXbNaaw7trB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 13:26 +0200, Pavel Machek wrote:

> Yes, probably will. The other option is to break existing 32-bit
> userspace, which is a bit more common AFAICT.

Judging from experience with the wext 32/64 bit fiasco it seems to be
rather uncommon to use 32-bit userspace on 64-bit machines.

Rafael hinted that we could just add these numbers, keep the existing
ones and then phase them out over time, but I haven't really given it
much thought.

johannes

--=-Kg1mehxX2cXbNaaw7trB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMI5r/ETPhpq3jKURAkCoAJ0cKVc85zsXmvoc2K3GvRgzWTCo9QCgn+07
NgJ9MPxllCzCDs25avLbqC0=
=YBav
-----END PGP SIGNATURE-----

--=-Kg1mehxX2cXbNaaw7trB--

