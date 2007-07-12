Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbXGLBxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbXGLBxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbXGLBxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:53:42 -0400
Received: from ozlabs.org ([203.10.76.45]:44186 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759421AbXGLBxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:53:41 -0400
Subject: Re: [PATCH 05/34] PCI: Use a weak symbol for the empty version of
	pcibios_add_platform_entries()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20070712005447.GY9704@parisc-linux.org>
References: <20070711233037.GB5253@kroah.com>
	 <11841967082916-git-send-email-gregkh@suse.de>
	 <1184196712526-git-send-email-gregkh@suse.de>
	 <11841967172946-git-send-email-gregkh@suse.de>
	 <11841967322884-git-send-email-gregkh@suse.de>
	 <11841967361726-git-send-email-gregkh@suse.de>
	 <20070711234922.GW9704@parisc-linux.org> <20070712003923.GA8132@suse.de>
	 <20070712005447.GY9704@parisc-linux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F/faPWQRsloa4r/HVZK0"
Date: Thu, 12 Jul 2007 11:53:38 +1000
Message-Id: <1184205218.17010.5.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F/faPWQRsloa4r/HVZK0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 18:54 -0600, Matthew Wilcox wrote:
> On Wed, Jul 11, 2007 at 05:39:23PM -0700, Greg KH wrote:
> > > This seems like a regression.  We go from having an empty inline
> > > function that gets optimised away to 0 to having a function call to a
> > > trivial function.  And on any architecture that *does* define this,
> > > (unless I misunderstand the GCC manual), we still include the weak
> > > definition, thus wasting space.

Regression is a little strong don't you think. I agree it wastes some
space, 1 instruction for an empty function?

> > Yeah, but it can be a big pain to add it to every architecture when onl=
y
> > 1 or two need it, which is why I see people using the week symbol stuff
> > more and more, right?  This is just following that trend.
>=20
> But it's already there.  Deleting it now is pointless.

It's not pointless, the following patch changes the prototype. So rather
than update the prototype on every architecture, all of which don't use
it (bar one) I thought it was much cleaner to get rid of it.

But I really don't mind, I just wanted to fix the damn warning.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-F/faPWQRsloa4r/HVZK0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlYmidSjSd0sB4dIRAu3NAKCYYVgHHr+XjErmSoxuvxe9bean1gCeIdc1
zIsKgI97axlp4nlg/PH7ETE=
=VIlF
-----END PGP SIGNATURE-----

--=-F/faPWQRsloa4r/HVZK0--

