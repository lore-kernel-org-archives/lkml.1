Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbYFJAVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbYFJAVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 20:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYFJAVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 20:21:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59633 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYFJAVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 20:21:35 -0400
Date: Tue, 10 Jun 2008 10:21:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: paulus@samba.org, geert@linux-m68k.org, zippel@linux-m68k.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/macintosh/: possible cleanups
Message-Id: <20080610102125.2816c9e3.sfr@canb.auug.org.au>
In-Reply-To: <20080609222312.GM1987@cs181133002.pp.htv.fi>
References: <20080609222312.GM1987@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jun_2008_10_21_25_+1000_GP8DqNLn=BRPWlgB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jun_2008_10_21_25_+1000_GP8DqNLn=BRPWlgB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Tue, 10 Jun 2008 01:23:12 +0300 Adrian Bunk <bunk@kernel.org> wrote:
>
> +++ b/drivers/macintosh/adbhid.c
> @@ -75,7 +75,7 @@ static struct notifier_block adbhid_adb_notifier =3D {
>  #define ADB_KEY_POWER_OLD	0x7e
>  #define ADB_KEY_POWER		0x7f
> =20
> -u16 adb_to_linux_keycodes[128] =3D {
> +static u16 adb_to_linux_keycodes[128] =3D {

This could be const as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jun_2008_10_21_25_+1000_GP8DqNLn=BRPWlgB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhNyQUACgkQTgG2atn1QN+jaQCgjKxLkVMCwhto8f8U1rI2yONg
C/sAnjB/q7BfS+jvF2cWpRQJWeVfrZ8T
=oEwN
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jun_2008_10_21_25_+1000_GP8DqNLn=BRPWlgB--
