Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0BTTw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 14:52:28 -0500
Received: from mx1.riseup.net ([204.13.164.18]:34153 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0BTTw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 14:52:27 -0500
From: Francisco Jerez <currojerez@riseup.net>
To: chris.nicholson@cnick.org.uk
Cc: airlied@linux.ie, bskeggs@redhat.com, madman2003@gmail.com,
       koriakin@0x04.net, tacconet@libero.it, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Gpu: drm: fix buffer overflow in nouveau_bios.c
References: <1266691783-25029-1-git-send-email-chris.nicholson@cnick.org.uk>
Date: Sat, 20 Feb 2010 20:58:15 +0100
In-Reply-To: <1266691783-25029-1-git-send-email-chris.nicholson@cnick.org.uk>
	(chris nicholson's message of "Sat, 20 Feb 2010 18:49:43 +0000")
Message-ID: <87aav3wug8.fsf@riseup.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

chris.nicholson@cnick.org.uk writes:

> From: Chris Nicholson <chris@port.cnick.org.uk>
>
> This is a patch to the nouveau_bios.c file that fixes up a
> buffer overflow
>
This bug was already fixed upstream (774baeb0ba92bcb082f9868726a27a015c9a0897).
In any case, thank you.

> Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bios.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
> index 0e9cd1d..c1cee91 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bios.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
> @@ -762,7 +762,7 @@ static uint32_t get_tmds_index_reg(struct drm_device *dev, uint8_t mlv)
>  			dacoffset ^= 8;
>  		return 0x6808b0 + dacoffset;
>  	} else {
> -		if (mlv > ARRAY_SIZE(pramdac_table)) {
> +		if (mlv >= ARRAY_SIZE(pramdac_table)) {
>  			NV_ERROR(dev, "Magic Lookup Value too big (%02X)\n",
>  									mlv);
>  			return 0;

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuAPtgACgkQ196Zy2qEI5eLUgCfYXOXZsWfuvHhgoVdhizHtFu2
GGIAnRmuy4Oazffw8wl9Xdz894eXylh6
=A4QF
-----END PGP SIGNATURE-----
--==-=-=--
