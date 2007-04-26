Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXDZRIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXDZRIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031358AbXDZRIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:08:46 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031344AbXDZRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:08:28 -0400
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
In-Reply-To: <20070426104052.GA19072@elf.ucw.cz>
References: <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <1177582633.6814.29.camel@johannes.berg>
	 <20070426103051.GP17387@elf.ucw.cz>  <20070426104052.GA19072@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cq4kHQcX8Z5UWySbuMjC"
Date: Thu, 26 Apr 2007 15:45:24 +0200
Message-Id: <1177595124.6814.77.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Cq4kHQcX8Z5UWySbuMjC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

By the way.

> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index eb461b8..dc13af5 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
        ^^^^^^^^^^^^^^^^^^^^

Don't these definitions need to be exported to userspace? That
definitely is not a header file for userspace.

johannes

--=-Cq4kHQcX8Z5UWySbuMjC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMKzz/ETPhpq3jKURAhceAJ9SBVuwgyYBWC+M4CjGS4VEXIrMvACgkLNQ
UrcPPbm320NvW3l+mgnltiU=
=dIOl
-----END PGP SIGNATURE-----

--=-Cq4kHQcX8Z5UWySbuMjC--

