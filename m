Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXIJRGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXIJRGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXIJRGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:06:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40431 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbXIJRGd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:06:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sami Farin <safari-kernel@safari.iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Broken mail setup
In-Reply-To: Your message of "Mon, 10 Sep 2007 14:39:34 BST."
             <20070910143934.1a695d54@the-village.bc.nu>
From: Valdis.Kletnieks@vt.edu
References: <20070910135912.29ad26e8@the-village.bc.nu> <20070910132042.33g4fhsgra4bzysh@m.safari.iki.fi>
            <20070910143934.1a695d54@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189443970_3022P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Sep 2007 13:06:10 -0400
Message-ID: <7375.1189443970@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189443970_3022P
Content-Type: text/plain; charset=us-ascii

On Mon, 10 Sep 2007 14:39:34 BST, Alan Cox said:
> On Mon, 10 Sep 2007 16:20:42 +0300
> Sami Farin <safari-kernel@safari.iki.fi> wrote:
> 
> > On Mon, Sep 10, 2007 at 13:59:12 +0100, Alan Cox wrote:
> > > Will RMK (rmk@arm.linux.org.uk) please fix his email setup otherwise I
> > > can't send serial/tty/arm stuff to him.
> > > 
> > > "<<< 550 You have no reverse DNS; please try again when you have resolved
> > 
> > Well, outpipe-village-512-1.bc.nu is NXDOMAIN.
> > It should have A record 81.2.110.250.
> 
> I've yet to see a specification which requires this.

RFC1912 is admittedly "Informational" status. However, it *does* say:

2.1 Inconsistent, Missing, or Bad Data

   Every Internet-reachable host should have a name.  The consequences
   of this are becoming more and more obvious.  Many services available
   on the Internet will not talk to you if you aren't correctly
   registered in the DNS.

   Make sure your PTR and A records match.  For every IP address, there
   should be a matching PTR record in the in-addr.arpa domain.  If a
   host is multi-homed, (more than one IP address) make sure that all IP
   addresses have a corresponding PTR record (not just the first one).
   Failure to have matching PTR and A records can cause loss of Internet
   services similar to not being registered in the DNS at all.  Also,
   PTR records must point back to a valid A record, not a alias defined
   by a CNAME.  It is highly recommended that you use some software
   which automates this checking, or generate your DNS data from a
   database which automatically creates consistent data.

That advice came out in Feb 1996.  You're being bit by the 3rd sentence.

--==_Exmh_1189443970_3022P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG5XmCcC3lWbTT17ARAk/lAKCao1c4fPX6b79nJd/qRz61Cgq2/QCeMFww
zQFOYJKqTKYHTCmql31NuD8=
=LOSK
-----END PGP SIGNATURE-----

--==_Exmh_1189443970_3022P--
