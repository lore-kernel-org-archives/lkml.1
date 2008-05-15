Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYEOHXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYEOHXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYEOHXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:23:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38042 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYEOHXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:23:22 -0400
Date: Thu, 15 May 2008 17:23:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for May 14
Message-Id: <20080515172310.6583453e.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0805150914220.11631@anakin>
References: <20080514170106.3cbcb201.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0805142237240.11631@anakin>
	<20080514135008.60e5df96.randy.dunlap@oracle.com>
	<20080514210447.GK20457@bakeyournoodle.com>
	<20080515010550.GL20457@bakeyournoodle.com>
	<Pine.LNX.4.64.0805150914220.11631@anakin>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_May_2008_17_23_10_+1000_h9SG_wfJgFPtAFre"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_May_2008_17_23_10_+1000_h9SG_wfJgFPtAFre
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Thu, 15 May 2008 09:17:15 +0200 (CEST) Geert Uytterhoeven <geert@linux-m=
68k.org> wrote:
>
> Wow, did you really get all of this from that webpage??

No, he didn't.  He reran the build by hand.  Sorry, but there appears to
a bug somewhere in our build system (or one of the tools it is using)
that very occasionally loses a line of the log.  We are trying to track
it down.

> > The patch below fixes the zorro8390 build, and I think will keep the wa=
rnings
> > that Jeff is trying to silence silenced.

I have applied this patch to today's linux-next, so that this particular
bug will not prevent the m68k builds.  I am hoping someone will pick it
up (or an equivalent patch) so I can drop it again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_May_2008_17_23_10_+1000_h9SG_wfJgFPtAFre
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIK+TmTgG2atn1QN8RAgCpAJsGoCnHoEreHK3VwUDqPfr/0GPN0wCfbPqO
bAISpwUqIcYB6hBlPoKXg+0=
=kt78
-----END PGP SIGNATURE-----

--Signature=_Thu__15_May_2008_17_23_10_+1000_h9SG_wfJgFPtAFre--
