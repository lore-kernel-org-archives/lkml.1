Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYBOP3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYBOP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYBOP3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:29:32 -0500
Received: from frost.carfax.org.uk ([212.13.194.111]:1130 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYBOP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:29:30 -0500
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 10:29:30 EST
Date: Fri, 15 Feb 2008 15:04:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Spurious completions during NCQ
Message-ID: <20080215150449.GC27745@vlad.carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
	Calvin Walton <calvin.walton@gmail.com>,
	Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <20080215134658.GB27745@vlad.carfax.org.uk> <1203087600.25150.5.camel@zem>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <1203087600.25150.5.camel@zem>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.13 (2006-08-11)
X-frost.carfax.org.uk-Spam-Score: -2.6 (--)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "admin.curacao.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Fri, Feb 15, 2008 at 10:00:00AM -0500, Calvin Walton wrote:
	> On Fri, 2008-02-15 at 13:46 +0000, Hugo Mills wrote: > > I'm getting these
	on my Dell Latitude D830: > > > > Feb 15 13:06:00 willow kernel: ata1.00:
	exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen > > Feb 15 13:06:00
	willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4
	FIS=004040a1:00000002 > > > In some cases, there are several cmd/res lines
	listed. It's > > happening about once an hour or so (not correlated with
	any other > > event that I can see). It doesn't seem to be affecting operation
	of > > the machine, but it's making me nervous. > > > > Can anyone set my
	mind at rest? (Or suggest a fix?) > > You didn't mention which SATA chipset
	your laptop has, but some quick > googling says that it's AHCI. Until 2.6.24,
	the AHCI driver has a > problem where it'll report superious NCQ completions
	due to a bug in the > driver logic. > > > uname -a reports: > > Linux willow
	2.6.23.1-hrt3 #1 SMP Sun Nov 4 14:51:20 GMT 2007 x86_64 GNU/Linux > > The
	fix is simple, upgrade your kernel to 2.6.24 :) [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2008 at 10:00:00AM -0500, Calvin Walton wrote:
> On Fri, 2008-02-15 at 13:46 +0000, Hugo Mills wrote:
> > I'm getting these on my Dell Latitude D830:
> > 
> > Feb 15 13:06:00 willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
> > Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002
> 
> >    In some cases, there are several cmd/res lines listed. It's
> > happening about once an hour or so (not correlated with any other
> > event that I can see). It doesn't seem to be affecting operation of
> > the machine, but it's making me nervous.
> > 
> >    Can anyone set my mind at rest? (Or suggest a fix?)
> 
> You didn't mention which SATA chipset your laptop has, but some quick
> googling says that it's AHCI. Until 2.6.24, the AHCI driver has a
> problem where it'll report superious NCQ completions due to a bug in the
> driver logic.
> 
> > uname -a reports:
> > Linux willow 2.6.23.1-hrt3 #1 SMP Sun Nov 4 14:51:20 GMT 2007 x86_64 GNU/Linux
> 
> The fix is simple, upgrade your kernel to 2.6.24 :)

   Excellent. Thank you for clearing this up for me. I'll head off and
do the upgrade now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- All mushrooms are edible,  but some are only edible once. ---    

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtaoRIKyzvlFcI40RAld/AJ9ciHYEcPF1Kr6spz4UMMgkXsEa9gCeJuGp
9VkYC7UwdoZC08b9YAHQWvo=
=zh1y
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
