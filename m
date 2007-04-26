Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXDZLi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXDZLi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030685AbXDZLi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:38:27 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668AbXDZLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:38:26 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070426113005.GU17387@elf.ucw.cz>
References: <20070425072350.GA6866@ucw.cz>
	 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
	 <1177583998.6814.42.camel@johannes.berg>
	 <20070426113005.GU17387@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UypE5khZu+UZgyYq3MPg"
Date: Thu, 26 Apr 2007 13:41:42 +0200
Message-Id: <1177587702.6814.60.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UypE5khZu+UZgyYq3MPg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 13:30 +0200, Pavel Machek wrote:

> That code goes back to Patrick, AFAICT. (And yes, ACPI S3 and ACPI S4
> low-level enter is pretty similar).

But that doesn't excuse abusing the same interface, IMHO.

> Patches would be welcome

:) I'll see what I can do. Shouldn't be too hard to add an interface
just for ACPI here and get platform disk-mode into there from a
different angle.

johannes

--=-UypE5khZu+UZgyYq3MPg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMI/2/ETPhpq3jKURAo7aAJ4491M2StFUWq/vANGTRwLXG+BSlwCePSFG
hJvjj4JjnJe3LKsmt1N98mA=
=sDoe
-----END PGP SIGNATURE-----

--=-UypE5khZu+UZgyYq3MPg--

