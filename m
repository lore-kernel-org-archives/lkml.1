Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYFSFzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYFSFzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYFSFy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:54:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41046 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYFSFy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:54:58 -0400
Date: Thu, 19 Jun 2008 15:54:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, jeremy@xensource.com,
       chrisw@sous-sol.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org
Subject: Re: linux-next: Tree for June 18 (XEN build error)
Message-Id: <20080619155451.0a4ea6f8.sfr@canb.auug.org.au>
In-Reply-To: <4859E9B8.9040406@goop.org>
References: <20080618175753.2a519b71.sfr@canb.auug.org.au>
	<20080618124331.04e27900.randy.dunlap@oracle.com>
	<4859E9B8.9040406@goop.org>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Jun_2008_15_54_51_+1000_oPcnqRUAr122._Oi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jun_2008_15_54_51_+1000_oPcnqRUAr122._Oi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jun 2008 22:08:08 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> Randy Dunlap wrote:
> > linux-next-20080618/drivers/xen/manage.c: In function 'xen_suspend':
> > linux-next-20080618/drivers/xen/manage.c:66: error: too few arguments t=
o function 'device_power_up'
> > linux-next-20080618/drivers/xen/manage.c: In function 'do_suspend':
> > linux-next-20080618/drivers/xen/manage.c:115: error: too few arguments =
to function 'device_resume'
> > make[3]: *** [drivers/xen/manage.o] Error 1
> >  =20
>=20
> What argument(s) do device_power_up() and device_resume() want now?

In today's linux-next:

void device_power_up(pm_message_t state)
void device_resume(pm_message_t state)

If someone can give me a patch, I can carry it in linux-next ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Jun_2008_15_54_51_+1000_oPcnqRUAr122._Oi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhZ9KsACgkQTgG2atn1QN+fYACeKC7yV15vkutEIZbGUn5uH56D
NpQAn0zV2NMklMGbyv5bqFkhEyJzA4SC
=+VnH
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jun_2008_15_54_51_+1000_oPcnqRUAr122._Oi--
