Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbXLQIIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbXLQIIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXLQIHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:07:53 -0500
Received: from mail1.perex.cz ([212.20.107.53]:51226 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbXLQIHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:07:52 -0500
Date: Mon, 17 Dec 2007 09:07:49 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alsa: fix SNDRV_PCM_IOCTL_TTSTAMP value.
In-Reply-To: <200712160136.30622.mboton@gmail.com>
Message-ID: <Pine.LNX.4.61.0712170905490.14817@tm8103.perex-int.cz>
References: <200712160136.30622.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1902097433-1197878869=:14817"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1902097433-1197878869=:14817
Content-Type: TEXT/PLAIN; charset=iso8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 16 Dec 2007, Miguel Bot=F3n wrote:

> "[ALSA] Use posix clock monotonic for PCM and timer timestamps" introduce=
s
> a bug that makes audio device unusable in some computers.
>=20
> Signed-off-by: Miguel Bot=F3n <mboton@gmail.com>

Thanks for notify that old alsa-lib binaries have trouble with this patch.=
=20
But your fix is wrong. New and old ioctls are incompatible. I added old=20
ioctl back to our HG tree.

=09=09=09=09=09Jaroslav

> diff --git a/include/sound/asound.h b/include/sound/asound.h
> index 475eb71..d35aa44 100644
> --- a/include/sound/asound.h
> +++ b/include/sound/asound.h
> @@ -443,7 +443,7 @@ enum {
>  enum {
>  =09SNDRV_PCM_IOCTL_PVERSION =3D _IOR('A', 0x00, int),
>  =09SNDRV_PCM_IOCTL_INFO =3D _IOR('A', 0x01, struct snd_pcm_info),
> -=09SNDRV_PCM_IOCTL_TTSTAMP =3D _IOW('A', 0x03, int),
> +=09SNDRV_PCM_IOCTL_TTSTAMP =3D _IOW('A', 0x02, int),
>  =09SNDRV_PCM_IOCTL_HW_REFINE =3D _IOWR('A', 0x10, struct snd_pcm_hw_para=
ms),
>  =09SNDRV_PCM_IOCTL_HW_PARAMS =3D _IOWR('A', 0x11, struct snd_pcm_hw_para=
ms),
>  =09SNDRV_PCM_IOCTL_HW_FREE =3D _IO('A', 0x12),
>=20
> --=20
> =09Miguel Bot=F3n
>=20

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project
--8323584-1902097433-1197878869=:14817--
