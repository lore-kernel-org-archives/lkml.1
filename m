Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZCAXqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZCAXqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZCAXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:46:22 -0500
Received: from ozlabs.org ([203.10.76.45]:56217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZCAXqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:46:21 -0500
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20090227121443.GL16891@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
	 <1235410082-5016-2-git-send-email-matthew@wil.cx>
	 <20090227061525.GA9883@colo.lackof.org>
	 <20090227121443.GL16891@parisc-linux.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WZfOc43aXjYJrQ49fcRk"
Date: Mon, 02 Mar 2009 10:46:18 +1100
Message-Id: <1235951178.8526.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WZfOc43aXjYJrQ49fcRk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 05:14 -0700, Matthew Wilcox wrote:
> On Thu, Feb 26, 2009 at 11:15:25PM -0700, Grant Grundler wrote:
> > ...
> > > +3. Why use MSIs?
> > > +
> > > +There are three reasons why using MSIs can give an advantage over
> > > +traditional pin-based interrupts.
> > ...
> > > +PCI devices can only support a single pin-based interrupt per functi=
on.
> >=20
> > Related to this is a 4th reason: distribute workload across CPUs
> > and enables construction of efficient, multi-queue devices.
> > Care to mention that?
>=20
> That's true for MSI-X, but not for MSIs in general.  Workload is already
> distributed across CPUs with round-robin interrupts.  I'm inclined to
> leave out this level of detail.
>=20
> > > +The MSI-X capability is much more flexible than the MSI capability.
> > > +It supports up to 2048 interrupts, each of which can be separately
> > > +assigned.
> >=20
> > Nothing describes "assignment" below or what is meant by "assigned".
> > My guess is you wanted to differentiate MSIX from MSI with:
> >   ... and each MSIX can be directed at a different CPU.

So might each MSI, depending on the hardware.

> > > +5.4. Finding why MSIs are disabled on a device
> > > +
> > > +From the above three sections, you can see that there are many reaso=
ns
> > > +why MSIs may not be enabled for a given device.  Your first step sho=
uld
> > > +be to examine your dmesg carefully to determine whether MSIs are ena=
bled
> > > +for your machine.  You should also check your .config to be sure you
> > > +have enabled CONFIG_PCI_MSI.
> >=20
> > Should mention "fgrep MSI /proc/interrupts" to see if any devices have
> > MSI in use?
>=20
> Yes, you're right.

That won't work on (some) powerpc machines at least .. because MSIs just
get routed into the regular PIC.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-WZfOc43aXjYJrQ49fcRk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmrHkoACgkQdSjSd0sB4dJ4lACgj6SctuHiUV9fVN7Pe/5oYpyV
SqIAoI4tODLQBgnFK9m1TgJzHKxXk8QA
=OL2T
-----END PGP SIGNATURE-----

--=-WZfOc43aXjYJrQ49fcRk--

