Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZJWBx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZJWBx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZJWBx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:53:27 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:35196 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZJWBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:53:26 -0400
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Eric Anholt <eric@anholt.net>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Schlichter <thomas.schlichter@web.de>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256256717.2534.6.camel@sbs-t61>
References: <1394846127@web.de>
	 <4ADF32A0020000780001B20A@vpn.id2.novell.com>
	 <20091021173514.GA32227@elte.hu>
	 <200910212201.36578.thomas.schlichter@web.de>
	 <1256205210.2530.28.camel@sbs-t61>
	 <1256225689.32075.6.camel@gaiman.anholt.net>
	 <1256248050.2546.9.camel@sbs-t61>  <20091023081047.4d8abc29@jbarnes-x200>
	 <1256256717.2534.6.camel@sbs-t61>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uTzHHxb5+7CDQs6cf6Dn"
Date: Thu, 22 Oct 2009 18:53:19 -0700
Message-Id: <1256262799.15120.8.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uTzHHxb5+7CDQs6cf6Dn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 17:11 -0700, Suresh Siddha wrote:
> On Thu, 2009-10-22 at 16:10 -0700, Jesse Barnes wrote:
> > On Thu, 22 Oct 2009 14:47:30 -0700
> > Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >=20
> > > On Thu, 2009-10-22 at 08:34 -0700, Eric Anholt wrote:
> > > > Can we just not create the _wc sysfs entry if we don't have PAT?  I
> > > > don't think there's userland relying on its presence as opposed to
> > > > the non-_wc entry.
> > >=20
> > > Yes indeed. Jesse do you see an issue with this? This is simple and
> > > clean. Thanks Eric.
> >=20
> > Yeah, I think that will be fine.  In fact, older versions of
> > libpciaccess will behave better if we do it that way (iirc it only
> > allocates an MTRR if the resource_wc file doesn't exist or fails to get
> > mapped).
>=20
> Eric, care to send the patch?

I don't have a patch, I was just suggesting a way to handle the
submitter's problem that won't involve complicated changes that nobody
else will be testing since everyone *should* have a graphics driver for
their graphics hardware.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-uTzHHxb5+7CDQs6cf6Dn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrhDI8ACgkQHUdvYGzw6vfDewCfaqYR5TjG0zpwoH4xd+zJ2FlO
6SEAn2ES4srqXKhLObGI8ROujoiHxAba
=1JuF
-----END PGP SIGNATURE-----

--=-uTzHHxb5+7CDQs6cf6Dn--

