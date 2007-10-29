Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXJ2XIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXJ2XIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJ2XIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:08:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57976 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbXJ2XID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:08:03 -0400
X-Sasl-enc: TjlrtYIUlEuPOVmq3L8KrceX7RMkIN/v+4CZmVu266XH 1193699281
Message-ID: <472667EB.4030502@imap.cc>
Date: Tue, 30 Oct 2007 00:08:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Emil Medve <Emilian.Medve@Freescale.com>
CC: mochel@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       hjlipp@web.de, gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH resend] Make the dev_*() family of macros in device.h
 complete
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
In-Reply-To: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE2CF69EA2B09C1135AC10B22"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE2CF69EA2B09C1135AC10B22
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 29.10.2007 23:43 schrieb Emil Medve:
> Removed duplicates defined elsewhere
>=20
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>

Acked-by: Tilman Schmidt <tilman@imap.cc>

for:

> diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/giga=
set.h
> index a0317ab..02bdaf2 100644
> --- a/drivers/isdn/gigaset/gigaset.h
> +++ b/drivers/isdn/gigaset/gigaset.h
> @@ -106,12 +106,6 @@ enum debuglevel {
>  					 activated */
>  };
> =20
> -/* missing from linux/device.h ... */
> -#ifndef dev_notice
> -#define dev_notice(dev, format, arg...)		\
> -	dev_printk(KERN_NOTICE , dev , format , ## arg)
> -#endif
> -
>  /* Kernel message macros for situations where dev_printk and friends c=
annot be
>   * used for lack of reliable access to a device structure.
>   * linux/usb.h already contains these but in an obsolete form which cl=
utters

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE2CF69EA2B09C1135AC10B22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJmfrMdB4Whm86/kRApJ0AJ0TndU2phadwTNtqF6Z2xPA18hAvQCfXtGE
EbQDGodMYRpl62IWLo5towM=
=7/H2
-----END PGP SIGNATURE-----

--------------enigE2CF69EA2B09C1135AC10B22--
