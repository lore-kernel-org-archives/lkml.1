Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZKBQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZKBQ4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZKBQ4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:56:07 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:55979
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbZKBQ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:56:06 -0500
Date: Mon, 2 Nov 2009 14:56:09 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: remove pci_find_slot from PCI_LEGACY config
	description
Message-ID: <20091102165608.GB20277@vespa.holoscopio.com>
References: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com> <alpine.LSU.2.00.0911021648320.4203@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911021648320.4203@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2009 at 04:49:01PM +0100, Jiri Kosina wrote:
> On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:
>=20
> > Commit 3b073eda has removed pci_find_slot, so there's no point in
> > mentioning it in the config description as one of the deprecated APIs
> > there are enabled by PCI_LEGACY and still used by some drivers.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  drivers/pci/Kconfig |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > index fdc864f..48a3ea7 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -27,10 +27,10 @@ config PCI_LEGACY
> >  	default y
> >  	help
> >  	  Say Y here if you want to include support for the deprecated
> > -	  pci_find_slot() and pci_find_device() APIs.  Most drivers have
> > -	  been converted over to using the proper hotplug APIs, so this
> > -	  option serves to include/exclude only a few drivers that are
> > -	  still using this API.
> > +	  pci_find_device() API.  Most drivers have been converted over
> > +	  to using the proper hotplug APIs, so this option serves to
> > +	  include/exclude only a few drivers that are still using this
> > +	  API.
>=20
> While you are at it, how about removing the references in=20
> Documentation/PCI/pci.txt as well?
>=20
> Thanks,
>=20
> --=20
> Jiri Kosina
> SUSE Labs, Novell Inc.

I've hit them. But, on a first fast look, they seemed important
historically. I will take a closer look and point that if it's proper or
remove them entirely as you suggest.

Regards,
Cascardo.

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrvDygACgkQyTpryRcqtS2kyACeO6LXR+c/meIHBgjpX8DhR2gx
X64An1Jp8Piq/mkkZPiairVlq8+Uz98i
=dQPg
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
