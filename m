Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYCFMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYCFMLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYCFMLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:11:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53346 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYCFMK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:10:59 -0500
Date: Thu, 6 Mar 2008 23:10:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] linux-next: Tree for March 6 drivers/usb broken
Message-Id: <20080306231046.69493270.sfr@canb.auug.org.au>
In-Reply-To: <47CFB6EE.5050307@linux.vnet.ibm.com>
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
	<47CFB6EE.5050307@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Mar_2008_23_10_46_+1100_o0_vFoSOiW3QcCZ/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2008_23_10_46_+1100_o0_vFoSOiW3QcCZ/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 06 Mar 2008 14:48:38 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> The kernel build fails with error
>=20
> drivers/usb/core/hub.c: In function 'persist_enabled':
> drivers/usb/core/hub.c:633: error: 'struct usb_device' has no member name=
d 'persist_enabled'
> drivers/usb/core/hub.c: In function 'hub_restart':
> drivers/usb/core/hub.c:719: error: 'struct usb_device' has no member name=
d 'reset_resume'
> make[3]: *** [drivers/usb/core/hub.o] Error 1
> make[2]: *** [drivers/usb/core] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2
>=20
> This is introduced by persist_enabled() and # CONFIG_PM is not set

Thanks for the report - I should read ahead more before sending my own
reports. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Mar_2008_23_10_46_+1100_o0_vFoSOiW3QcCZ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHz99LTgG2atn1QN8RAgfEAKCAXoZLD5Gqo8+2OLahgRjlg3cdAACffvQG
OG3GoNUFCXR/7Nl6zXl5dgI=
=EksH
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2008_23_10_46_+1100_o0_vFoSOiW3QcCZ/--
