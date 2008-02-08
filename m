Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbYBHPS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbYBHPS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYBHPSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:18:52 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:54290 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757950AbYBHPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:18:51 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Fri, 8 Feb 2008 16:18:42 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <20080208113638.GA4745@one.firstfloor.org> <200802081613.39906.prakash@punnoor.de>
In-Reply-To: <200802081613.39906.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart75157192.SA54mOBiPZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802081618.42961.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart75157192.SA54mOBiPZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 08 February 2008 Prakash Punnoor hast written:
> On the day of Friday 08 February 2008 Andi Kleen hast written:
> > On Thu, Feb 07, 2008 at 10:21:18PM +0100, Prakash Punnoor wrote:
> > > On the day of Thursday 07 February 2008 Andi Kleen hast written:
> > > > Replace the old "for all of nvidia" quirk with a quirk containing p=
ci
> > > > device ID. I goobled this list together from pci.ids and googling a=
nd
> > > > it may be incomplete, but so far I haven't had complaints.
> > > >
> > > > +	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4
> > > > ? */
> > >
> > > If you want to skip timer override on this board, this is a *NAK* from
> > > me. I told you the last time, it only works reliably here on MCP51 wi=
th
> > > timer
> >
> > Hmm, if you told me it got lost somewhere, sorry.
>
> I at least found this post: http://lkml.org/lkml/2006/8/13/2 though I
> remeber we had some discussions. ;-)

http://lkml.org/lkml/2006/8/13/25

I killed one digit by mistake...
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart75157192.SA54mOBiPZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrHLSxU2n/+9+t5gRAtf+AJsEHtPo7sA8Vdtp0xson4r4OzUGDQCg1Hm0
dcjGFQUpYxdu8IYgCKbI558=
=RCgL
-----END PGP SIGNATURE-----

--nextPart75157192.SA54mOBiPZ--
