Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYBIRad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYBIRad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbYBIRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:30:25 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:50832 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862AbYBIRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:30:23 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 18:30:16 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802091651.06240.prakash@punnoor.de> <20080209165619.GB24548@one.firstfloor.org>
In-Reply-To: <20080209165619.GB24548@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1461353.rQbQDuNdiE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802091830.20827.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1461353.rQbQDuNdiE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 09 Februar 2008 schrieben Sie:
> On Sat, Feb 09, 2008 at 04:51:05PM +0100, Prakash Punnoor wrote:
> > On the day of Saturday 09 February 2008 Andi Kleen hast written:
> > > We discussed this back then with Nvidia engineers and they stated
> > > that only NF5 would need timer overrides.
> >
> > Can I get a link which verifies your statement? I provided one which ki=
nd
> > of contradicts yours.
>
> Sorry cannot supply links to them, they were private mail. For some
> reason the Nvidia people seem to be shy to post to mailing lists.

Too bad that you cannot make them publish their infos.

>
> iirc the thread which inspired this patch (together with several
> bugs in both novell and kernel.org bugzilla) was
>
> http://marc.info/?t=3D116175224500001&r=3D1&w=3D2

Interesting, this was where I posted, as well...

> So you have to trust me on that -- it's a bit similar to as to I have
> to trust your not yet produced boot log and test results.

And I won't, as I reverted to my stable kernel again and thus patching it=20
again (yes it was 2.6.24 with early-quirks.c from git and your patch on top=
)=20
doesn't give more info then I already provided. Furthermore I also told you=
=20
that because of missing nforce2 ID the practical test wasn't really=20
necessary.


Just add this line to your patch:

+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2,=20
nvidia_timer),


So that the quirk gets applied for nForce2, then your patch is - while stil=
l=20
wrong in my eyes - not a regression anymore (for me) and thus I would take=
=20
back my NAK(, but still not ACK it).

bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1461353.rQbQDuNdiE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHreMsxU2n/+9+t5gRAvfYAJ9+XRyGSq4uLavJFJq/Kz3t0Q6XMwCfb2JO
Nt6uypT1keT3SgndhPVM3qM=
=xcwx
-----END PGP SIGNATURE-----

--nextPart1461353.rQbQDuNdiE--
