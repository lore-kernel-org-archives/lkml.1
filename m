Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYBYVTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYBYVTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYBYVTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:19:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36752 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBYVTc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:19:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
In-Reply-To: Your message of "Mon, 25 Feb 2008 21:27:10 +0200."
             <20080225192710.GA13635@cs181133002.pp.htv.fi>
From: Valdis.Kletnieks@vt.edu
References: <30804.1203962369@turing-police.cc.vt.edu> <47C3078E.3000008@redhat.com> <20080225181957.4eeed15d@core>
            <20080225192710.GA13635@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203974272_3315P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Feb 2008 16:17:52 -0500
Message-ID: <14633.1203974272@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203974272_3315P
Content-Type: text/plain; charset=us-ascii

On Mon, 25 Feb 2008 21:27:10 +0200, Adrian Bunk said:
> On Mon, Feb 25, 2008 at 06:19:57PM +0000, Alan Cox wrote:
(Following was actually Steve Rostedt writing):
> > > The reason I added GPL is not because of some idea that this is all 
> > > "chummy" with the kernel. But because I derived the mcount code from 
> > > glibc's version of mcount. Now you may argue that glibc is under LGPL 
> > > and a non-GPL export is fine. But I've been advised that if I ever take 
> > > code from someone else, to always export it with GPL.

Did the person giving that advice say that was OK, even with code that
originally had a more permissive license, such as the LGPL code from glibc?

> > As I understand it if Vladis wants to submit his own change to the symbol
> > thats up to him, and he'll be liable for any fallout with the FSF, or
> > harm to Linux resulting, so long he's the one who signs it off.
> >...
> 
> Why isn't anyone distributing it liable if it is not legally correct?

Particularly since there isn't any *real* legal distinction between the EXPORT
and EXPORT_GPL - anybody who can cite actual case law, rather than just "we
kernel nerds think and our lawyers mumble" is invited to do so. In the case of
'mcount', we're specifically talking about a symbol that's only referenced
*because the kernel's include files and config tell it to*.  It's not even a
reference the code includes - it's a reference included *BY THE COMPILER*.

I'd love to see how you'd argue this in court - "Your honor, this static piece
of source code is infringing on our copyright as a derivative work, even though
it in no way shape or form references the symbol, depending on a compiler flag,
which is out of the code author's control".

Based on that, I'd have to say that the actual abuse of the GPL, if any,
lies with the maintainers of GCC, since gcc is what created the reference to
the problematic symbol, not the authors of the actual source code.

--==_Exmh_1203974272_3315P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHwzCAcC3lWbTT17ARAn4UAKDKBr9yh29aBWK6tXDRC2vL28bCXACdGO2R
/f6Sw7erhyDFbP8/7AhGIo0=
=+FrI
-----END PGP SIGNATURE-----

--==_Exmh_1203974272_3315P--
