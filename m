Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYEWNX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYEWNX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYEWNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:23:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52577 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYEWNXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:23:47 -0400
Date: Fri, 23 May 2008 23:23:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Switch apm to unlocked_kernel
Message-Id: <20080523232339.27a28b5b.sfr@canb.auug.org.au>
In-Reply-To: <20080523120617.6a4c115c@core>
References: <20080522212204.177410b8@core>
	<20080523110353.7a1360b5.sfr@canb.auug.org.au>
	<20080523120617.6a4c115c@core>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_May_2008_23_23_39_+1000_8vx.3moP3eguKEPb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_May_2008_23_23_39_+1000_8vx.3moP3eguKEPb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Fri, 23 May 2008 12:06:17 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> Andrew shouts at me if I send him patches that don't fix the style of
> the lines around so you get some style changes even when I cut bits out
> of diffs. I think that approach is *stupid* too and style should be done
> after for the entire file.

Then let the maintainer (nominally me) shout at Andrew.  I don't agree
with those style changes and we usually leave such purely stylistic
things to the maintainer of the file in question.  If Andrew requires
these changes, then Andrew is wrong about this.  It just confuses the
real changes and adds to the overheads of those trying to do reviews (of
which we have too few).  And in this case "fix" is in the eye of the
beholder.

If you (or Andrew) thinks that those style changes are necessary, then
send them separately and I will NAK them :-)  In this case it is pure
churn for absolutely no gain whatsoever.  Two of the hunks weren't even
anywhere near the real changes.

/me is letting the linux-next work go to his head :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_May_2008_23_23_39_+1000_8vx.3moP3eguKEPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINsVfTgG2atn1QN8RAjWiAJ9sUaJGEfYA6/wuPhCtcrHVdq00ywCdHM9F
wa+yDvc6VLCQQjl4JxwlWF0=
=xVat
-----END PGP SIGNATURE-----

--Signature=_Fri__23_May_2008_23_23_39_+1000_8vx.3moP3eguKEPb--
