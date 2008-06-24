Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYFXAi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYFXAi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYFXAiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:38:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37909 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYFXAiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:38:16 -0400
Date: Tue, 24 Jun 2008 10:38:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: paulus@samba.org, geert@linux-m68k.org, zippel@linux-m68k.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/macintosh/: possible cleanups
Message-Id: <20080624103804.ed76bf3a.sfr@canb.auug.org.au>
In-Reply-To: <20080623174657.GC4756@cs181140183.pp.htv.fi>
References: <20080609222312.GM1987@cs181133002.pp.htv.fi>
	<20080610102125.2816c9e3.sfr@canb.auug.org.au>
	<20080623174657.GC4756@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Jun_2008_10_38_04_+1000_=_m8JAN0957Le5hF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jun_2008_10_38_04_+1000_=_m8JAN0957Le5hF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2008 20:46:57 +0300 Adrian Bunk <bunk@kernel.org> wrote:
>
> On Tue, Jun 10, 2008 at 10:21:25AM +1000, Stephen Rothwell wrote:
> > Hi Adrian,
> >=20
> > On Tue, 10 Jun 2008 01:23:12 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> > >
> > > +++ b/drivers/macintosh/adbhid.c
> > > @@ -75,7 +75,7 @@ static struct notifier_block adbhid_adb_notifier =
=3D {
> > >  #define ADB_KEY_POWER_OLD	0x7e
> > >  #define ADB_KEY_POWER		0x7f
> > > =20
> > > -u16 adb_to_linux_keycodes[128] =3D {
> > > +static u16 adb_to_linux_keycodes[128] =3D {
> >=20
> > This could be const as well.
>=20
> Updated patch below.
>=20
> cu
> Adrian
>=20
>=20
> <--  snip  -->
>=20
>=20
> This patch contains the following possible cleanups:
> - make the following needlessly global code static:
>   - adb.c: adb_controller
>   - adb.c: adb_init()
>   - adbhid.c: adb_to_linux_keycodes[]  (also make it const)
>   - via-pmu68k.c: backlight_level
>   - via-pmu68k.c: backlight_enabled
> - remove the following unused code:
>   - via-pmu68k.c: sleep_notifier_list
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Jun_2008_10_38_04_+1000_=_m8JAN0957Le5hF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhgQewACgkQTgG2atn1QN8lBwCfU80Zq/XzTROgviNqOnNZ25ql
eP8AnRA4qSr1PqQybMgEPfZkDzpn9LFu
=ajUS
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jun_2008_10_38_04_+1000_=_m8JAN0957Le5hF--
