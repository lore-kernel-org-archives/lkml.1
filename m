Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZHJD5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZHJD5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZHJD5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:57:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48678 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZHJD5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:57:02 -0400
Date: Mon, 10 Aug 2009 13:56:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: linux-next: rr tree build failure
Message-Id: <20090810135656.193d0761.sfr@canb.auug.org.au>
In-Reply-To: <20090810135546.2f1d079a.sfr@canb.auug.org.au>
References: <20090803133203.81174a8e.sfr@canb.auug.org.au>
	<200908031422.28171.bjorn.helgaas@hp.com>
	<200908040848.27364.rusty@rustcorp.com.au>
	<20090810135546.2f1d079a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_13_56_56_+1000_22Eqm2U/gRh/WFFD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_13_56_56_+1000_22Eqm2U/gRh/WFFD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Aug 2009 13:55:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 4 Aug 2009 08:48:26 +0930 Rusty Russell <rusty@rustcorp.com.au> w=
rote:
> >
> > On Tue, 4 Aug 2009 05:52:27 am Bjorn Helgaas wrote:
> > > On Sunday 02 August 2009 09:32:03 pm Stephen Rothwell wrote:
> > > > Hi Rusty,
> > > >=20
> > > > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > > >=20
> > > > drivers/acpi/osl.c: In function 'bind_to_cpu0':
> > > > drivers/acpi/osl.c:194: error: implicit declaration of function 'se=
t_cpus_allowed'
>=20
> Still getting this ...
>=20
> > > Here's a patch to fix this.  Since Linus' tree still contains instanc=
es
> > > of set_cpus_allowed(), I'm guessing this patch should be added to the=
 rr
> > > tree?
>=20
> Since set_cpus_allowed_ptr() aleeady exists in Linus' tree, you could put
> that patch in your tree, Bjorn.

Actually "Len", sorry.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_13_56_56_+1000_22Eqm2U/gRh/WFFD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/mogACgkQjjKRsyhoI8zNkwCdHcsFJUQNTheCBSAoKWIWSjk4
rEwAnAvxzlTpBb4r5uSaZA9IVwiCfxfs
=k702
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_13_56_56_+1000_22Eqm2U/gRh/WFFD--
