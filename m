Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYLCR4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYLCR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYLCRz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:55:57 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:34816 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbYLCRz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:55:56 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: Problems with fakephp
Date: Wed, 3 Dec 2008 18:55:49 +0100
User-Agent: KMail/1.9.10
Cc: Trent Piepho <xyzzy@speakeasy.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de
References: <20081126074808.GE6539@plum> <200812031822.57197.eike-kernel@sf-tec.de> <20081203174318.GB26130@ldl.fc.hp.com>
In-Reply-To: <20081203174318.GB26130@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1581254.Gqpdfo8ndG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812031855.50874.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1581254.Gqpdfo8ndG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > Alex Chiang wrote:
> > > I think the way forward is:
> > >
> > > 	- merge in the function level hotplug patch
> >
> > Sorry that I don't get the point. To PCI Hotplug core or to fakephp?
>
> I was talking about Trent's patch to add the "remove" attribute
> to the pci-sysfs. Not fakephp.
>
> > > 	- wholesale replacement of fakephp with new fakephp
> > > 	- schedule new fakephp for deprecation
> >
> >                    ^^^
> >
> > I don't think so.
>
> If we get function level reset as part of the PCI core, then I
> don't see what fakephp offers us anymore.

Why add a new fakephp if you want to remove it right after that?

> > > 	- encourage anyone who wants function level hotplug to
> > > 	  use the 'remove' attribute
> > >
> > > Thoughts? Jesse, Willy, Eike, Greg?
> >
> > Oh yes, let's start using dummyphp ;) That one already handled
> > the rescan long ago. But I think it's a bit outdated at the
> > moment, I haven't touched it for month. Looks like I need to
> > bring it back to live.
>
> I take it you are not impressed with my proposal? Care to explain why not?

It's a long fight between me and Greg about fakephp. I wrote dummyphp, fake=
php=20
is a for of an early version of dummyphp that I never liked. So if anyone=20
comes up with "fakephp can not do $foobar" my first answer is "try dummyphp=
".=20
So if you want to remove fakephp I'm the first do support you *eg* Yes, thi=
s=20
probably is mostly personal taste and not so much technical, but I'm just=20
human ;)

Eike

--nextPart1581254.Gqpdfo8ndG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk2yCYACgkQXKSJPmm5/E5cLgCeNfv+mpZeJdrms9DOo4qrRbyU
yu4AnR1bNCktiGXvX0M+0E3AW7mhteZj
=xat/
-----END PGP SIGNATURE-----

--nextPart1581254.Gqpdfo8ndG--
