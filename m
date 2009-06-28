Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZF1QrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZF1QrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZF1QrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:47:14 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:40479 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZF1QrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:47:13 -0400
Date: Sun, 28 Jun 2009 12:47:16 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Staging: vt6656 ?
Message-ID: <20090628164716.GC9143@alittletooquiet.net>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <200906281543.12745.bzolnier@gmail.com> <20090628135731.GA9143@alittletooquiet.net> <200906281759.46152.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
X-PGP-Key: http://www.alittletooquiet.net/media/forest.pubkey.asc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: multipart/mixed; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 28, 2009 at 05:59:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 28 June 2009 15:57:31 Forest Bond wrote:
> > Hi,
> >=20
> > On Sun, Jun 28, 2009 at 03:43:12PM +0200, Bartlomiej Zolnierkiewicz wro=
te:
> > >=20
> > > Hi,
> > >=20
> > > On Tuesday 09 June 2009 13:33:43 Forest Bond wrote:
> > > > Hi,
> > > >=20
> > > > On Tue, Jun 09, 2009 at 03:51:01AM -0700, Greg KH wrote:
> > > > > On Tue, Jun 09, 2009 at 02:31:30PM +0400, Alexander Beregalov wro=
te:
> > > > > > Hi Greg, Forest
> > > > > >=20
> > > > > > Are you going to merge driver for VT6656 also?
> > > > >=20
> > > > > If someone sends me some patches for it, sure, I will.
> > > >=20
> > > > I have patches almost ready.  I'll send them by the end of next wee=
k at the
> > > > latest.  Busy week here.
> > >=20
> > > Did I miss the patch?  There are people already doing cleanups for VT=
6655
> > > driver (which seems to share a great deal of code with VT6656 driver)=
 so
> > > it would greatly help to get VT6656 merged ASAP and merge the shared =
code
> > > first to not duplicate efforts.
> > >=20
> > > Also if you need some help with integrating the driver or hosting pat=
ches
> > > in git tree at kernel.org before Greg picks them up [ he seems to be =
buried
> > > alive by patches at the moment :) ] I'll be happy to help..
> >=20
> > I sent it to Greg about two weeks ago.  I assume it is in his queue som=
ewhere.
>=20
> There seems to be a lot of stuff in his queue.. ;)
>=20
> > Let me know if you think I ought to do something else with them.
>=20
> Please re-post with cc:ing linux-kernel so people looking for them (i.e. =
me)
> can pick them up from the list if needed (please also cc: lkml on all pat=
ches
> in the future, thanks!).

Okay.  The first patch is quite large, so I will compress it.

> [ I'll later setup vt665x branch of my misc.git tree, merge your patches,
>   merge all outstanding vt6655 patches from Alexander and investigate a b=
it
>   more whether merge of vt665x drivers is feasible and what needs to be
>   done if so.. ]

Good.

FYI, there is a known issue with the drivers as I've submitted them that ca=
uses
lock-ups.  Please see the attached message for a suggested fix.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=iso-8859-1
Content-Description: Fix for vt6656/v6655 driver lock ups.
Content-Disposition: attachment; filename="eml.txt"
Content-Transfer-Encoding: quoted-printable

=46rom: Olivier Blin <blino@mandriva.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: G=E1bor Stefanik <netrolller.3d@gmail.com>, Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Bcc:=20
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Reply-To:=20
In-Reply-To: <20090601165207.GA12481@alittletooquiet.net>
X-Spam-Status: No, score=3D-4.6 required=3D4.8 tests=3DAWL,BAYES_00 autolea=
rn=3Dham
	version=3D3.2.5

Forest Bond <forest@alittletooquiet.net> writes:

> Hi,
>
> On Mon, Jun 01, 2009 at 06:35:35PM +0200, G=E1bor Stefanik wrote:
>> On Tue, Apr 14, 2009 at 12:52 PM, Forest Bond
>> <forest@alittletooquiet.net> wrote:
>> > This patch adds the vt6656 driver to drivers/staging. =A0This code was=
 literally
>> > copied from the upstream source archive, available here:
>> >
>> > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
>> >
>> > Copyright: VIA Networking Technologies, Inc.
>> > License: GPL
>> > Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, War=
ren Hsu,
>> > =A0 =A0 =A0 =A0 Yiching Chen
>> > Signed-off-by: Forest Bond <forest@alittletooquiet.net>
>> >
>> > Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-drive=
r-to-drivers-staging.patch.gz
>> > Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-d=
river-to-drivers-staging.patch.gz.sig
>>=20
>> Did this patch (along with the vt6655 one) somehow get lost? I can't
>> see it in drivers/staging.
>
> vt6655 is in drivers/staging on linux-next, although I have three more pa=
tches
> that I'll be sending to Greg sometime tonight.  He has been applying them=
 for
> me.
>
> vt6656 is currently delayed a bit.  I may be able to get a start on that
> tonight, as well, but there is likelihood of further delay.

By the way, are you sure about the hook below about wpactl.c in commit
8f2c32b86b3ac16ba4c93bf0c2b766089644d9d1 ?

If I do the same in vt6656, it is freezing the kernel, or causing random
crashes. Removing the netdev priv assignation makes the driver ok.
I don't think the wpa priv was really useful, but I fail to see where it
was used, and why it caused the hang.

Don't you have the same issue with vt6655?

BTW, I have some patches to send for vt6656, what is the proper place to
submit them since vt6656 is not in staging for now?

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpact=
l.c
index ee7109d..cc4f0ad 100644 (file)
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
=20
 static int wpa_init_wpadev(PSDevice pDevice)
 {
+    PSDevice wpadev_priv;
        struct net_device *dev =3D pDevice->dev;
          int ret=3D0;
=20
-       pDevice->wpadev =3D alloc_netdev(0, "vntwpa", wpadev_setup);
+       pDevice->wpadev =3D alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev=
_setup);
        if (pDevice->wpadev =3D=3D NULL)
                return -ENOMEM;
=20
-       pDevice->wpadev->priv =3D pDevice;
+    wpadev_priv =3D netdev_priv(pDevice->wpadev);
+    *wpadev_priv =3D *pDevice;
+
        memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
          pDevice->wpadev->base_addr =3D dev->base_addr;
        pDevice->wpadev->irq =3D dev->irq;

--=20
Olivier Blin (blino) - Mandriva


--CblX+4bnyfN0pR09--

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR56URO4fQQdv5AwRAiv/AKC/ILY8rQe+a6WDs7l9U1OS2TjrUwCgpon5
t4x8JiWrFlXY0GW8XWZS8v8=
=+xSg
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
