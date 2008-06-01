Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYFAN05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYFAN05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 09:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYFAN0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 09:26:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37763 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYFAN0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 09:26:47 -0400
Date: Sun, 1 Jun 2008 23:26:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Diagnosing linux-next (Was: Re: m68k libc5 regression)
Message-Id: <20080601232638.fda1f3ab.sfr@canb.auug.org.au>
In-Reply-To: <20080601005338.3affe880.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__1_Jun_2008_23_26_38_+1000_oDyS78.d0Qkr+iv7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__1_Jun_2008_23_26_38_+1000_oDyS78.d0Qkr+iv7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Sun, 1 Jun 2008 00:53:38 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I do not know how to work out how this patch got into linux-next.

I have been wondering for a while what I can do to make figuring this out
(in general) easier.  Would adding the SHA1 of the head of each tree to
the Trees file help?  I could publish all the branches in my linux-next
repo - but they change daily.  I guess only the git users benefit from
those suggestions.

gitk can tell you pretty easily (just find the offending commit and work
your way upward until you find a merge by me).

Other suggestions?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__1_Jun_2008_23_26_38_+1000_oDyS78.d0Qkr+iv7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIQqOUTgG2atn1QN8RAstzAJ94xCYW+0coY4qtwb8UyMTcTcqzxwCgg+vE
TWS4rv1Ti9+JxNK3+cyp524=
=Mf7Y
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Jun_2008_23_26_38_+1000_oDyS78.d0Qkr+iv7--
