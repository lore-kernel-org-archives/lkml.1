Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342Ab0AEOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0AEOLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639Ab0AEOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:11:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab0AEOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:11:48 -0500
Date: Wed, 6 Jan 2010 01:11:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
Message-Id: <20100106011138.2743dad2.sfr@canb.auug.org.au>
In-Reply-To: <4B4345AF.9040600@suse.cz>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
	<4B4345AF.9040600@suse.cz>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Jan_2010_01_11_38_+1100__ICjRdeNNDbAtCPC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Jan_2010_01_11_38_+1100__ICjRdeNNDbAtCPC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Tue, 05 Jan 2010 14:59:11 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> Stephen, won't this break your linux-next scripts in any way? The final
> build won't change, because of the next-YYYYMMDD tag, but the builds in
> between will have the '+' appended to their version.

I think it should be OK - I don't depend on the kernel version for
anything until the very end.  If it does cause a problem, I am now
forwarned and can fix my scripts.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Jan_2010_01_11_38_+1100__ICjRdeNNDbAtCPC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktDSJoACgkQjjKRsyhoI8y3NACfXRXOEamX4uwOErzFZceMyXMm
4dkAoIt01xbAfIOqYGXSnkXKOy+8IieP
=EPt7
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Jan_2010_01_11_38_+1100__ICjRdeNNDbAtCPC--
