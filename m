Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXEJHCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXEJHCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXEJHBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:01:55 -0400
Received: from smtp1.yandex.ru ([213.180.223.87]:2514 "EHLO smtp1.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXEJHBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:01:54 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 03:01:54 EDT
X-Comment: RFC 2476 MSA function at smtp1.yandex.ru logged sender identity as: nshmyrev
Subject: Re: [PATCH 2/3] v4l: saa7134: enable ir-remote for 10moons TM300
	card
From: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
To: Tony Wan <wankai@sjtu.org>
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178766248.29993.41.camel@wankai.sjtu.org>
References: <1178766248.29993.41.camel@wankai.sjtu.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q4yeFoY5BmWgL41sy8j5"
Date: Thu, 10 May 2007 10:14:33 +0400
Message-Id: <1178777673.3120.6.camel@gnome.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 (2.9.5-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q4yeFoY5BmWgL41sy8j5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Tony. Very nice patch, thanks.

=D0=92 =D0=A7=D1=82=D0=B2, 10/05/2007 =D0=B2 11:04 +0800, Tony Wan =D0=BF=
=D0=B8=D1=88=D0=B5=D1=82:
> Enable the IR-remote of the 10moons TM300 card and add the key-codes for
> it's remote. But to enable all the keys, "IR_KEYTAB_SIZE", the size of
> code tables should be at least 256.

> It has been tested using lirc. All the key codes are accepted.
>=20
> This patch depends on the "[PATCH 1/3] v4l: Support 10moons TM300
> (saa7130) Card"
>=20
> Signed-off-by: Tony Wan <wankai@sjtu.org>
> ---
>  drivers/media/common/ir-keymaps.c           |   71
> +++++++++++++++++++++++++++
>  drivers/media/video/saa7134/saa7134-cards.c |    1 +
>  drivers/media/video/saa7134/saa7134-input.c |    6 ++
>  include/media/ir-common.h                   |    1 +
>  4 files changed, 79 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/media/common/ir-keymaps.c
> b/drivers/media/common/ir-keymaps.c
> index cbd1184..df11ed4 100644
> --- a/drivers/media/common/ir-keymaps.c
> +++ b/drivers/media/common/ir-keymaps.c
> @@ -1783,3 +1783,74 @@ IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE] =
=3D
> {
>  };
> =20
>  EXPORT_SYMBOL_GPL(ir_codes_tt_1500);
> +
> +/* 10MOONS TM300 */
> +IR_KEYTAB_TYPE ir_codes_10moonstm3[IR_KEYTAB_SIZE] =3D {
> +	[ 0x10 ] =3D KEY_POWER,           // Power
> +	[ 0x0d ] =3D KEY_MUTE,            // Mute
> +	[ 0x1e ] =3D KEY_TUNER,           // Cable
> +	[ 0x00 ] =3D KEY_VIDEO,           // Composite / S-Video
> +	[ 0x01 ] =3D KEY_RADIO,           // Music
> +	[ 0x02 ] =3D KEY_TEXT,            // Photo
> +
> +	[ 0x1f ] =3D KEY_1,
> +	[ 0x03 ] =3D KEY_2,
> +	[ 0x04 ] =3D KEY_3,
> +	[ 0x05 ] =3D KEY_4,
> +	[ 0x1c ] =3D KEY_5,
> +	[ 0x06 ] =3D KEY_6,
> +	[ 0x07 ] =3D KEY_7,
> +	[ 0x08 ] =3D KEY_8,
> +	[ 0x1d ] =3D KEY_9,
> +	[ 0x09 ] =3D KEY_SELECT,          // 2 digit select (-/--)
> +	[ 0x0a ] =3D KEY_0,
> +	[ 0x0b ] =3D KEY_AGAIN,           // Recall
> +
> +	[ 0x14 ] =3D KEY_F1,              // Begin
> +	[ 0x15 ] =3D KEY_F2,              // End
> +
> +	[ 0x16 ] =3D KEY_CHANNELUP,       // CH+
> +	[ 0x12 ] =3D KEY_CHANNELDOWN,     // CH-
> +	[ 0x0c ] =3D KEY_VOLUMEUP,        // VOL+
> +	[ 0x17 ] =3D KEY_VOLUMEDOWN,      // VOL-
> +	[ 0x18 ] =3D KEY_OK,              // OK
> +
> +	[ 0x0e ] =3D KEY_EXIT,            // Exit
> +	[ 0x13 ] =3D KEY_COMPUTER,        // Desktop
> +	[ 0x11 ] =3D KEY_TAB,             // TAB
> +	[ 0x19 ] =3D KEY_CYCLEWINDOWS,    // Switch task
> +
> +	[ 0x1a ] =3D KEY_MENU,            // Menu
> +	[ 0x1b ] =3D KEY_ZOOM,            // Fullscreen
> +#if IR_KEYTAB_SIZE>=3D256
> +	[ 0x84 ] =3D KEY_ARCHIVE,         // Time shifting
> +	[ 0x80 ] =3D KEY_SWITCHVIDEOMODE, // Selcect source
> +
> +	[ 0x9a ] =3D KEY_RECORD,          // Record
> +	[ 0x82 ] =3D KEY_PLAY,            // Play/Pause
> +	[ 0x85 ] =3D KEY_STOP,            // Stop
> +	[ 0x83 ] =3D KEY_CAMERA,          // Snapshot
> +
> +	[ 0x88 ] =3D KEY_BACK,            // Backward <<
> +	[ 0x8a ] =3D KEY_FORWARD,         // Forward >>
> +	[ 0x89 ] =3D KEY_PREVIOUS,        // Back |<<
> +	[ 0x8b ] =3D KEY_NEXT,            // End >>|
> +
> +	[ 0x8c ] =3D KEY_PROGRAM,         // Multi-view
> +	[ 0x8d ] =3D KEY_AUDIO,           // Audio Tracks
> +	[ 0x8e ] =3D KEY_SOUND,           // Sound
> +	[ 0x8f ] =3D KEY_SUBTITLE,        // Subtitles
> +
> +	[ 0x90 ] =3D KEY_TIME,            // Set timer
> +	[ 0x91 ] =3D KEY_CHANNEL,         // Stereo
> +	[ 0x92 ] =3D KEY_LANGUAGE,        // Language
> +	[ 0x93 ] =3D KEY_TEXT,            // Text
> +
> +	[ 0x99 ] =3D KEY_RED,             // RED
> +	[ 0x81 ] =3D KEY_GREEN,           // GREEN
> +	[ 0x87 ] =3D KEY_YELLOW,          // YELLOW
> +	[ 0x97 ] =3D KEY_BLUE,            // BLUE
> +#endif /* IR_KEYTAB_SIZE>=3D256 */
> +};
> +

Size of 256 is not required. You've just selected incorrect keymask,
that's why you have so big values. Look through your values, in the
upper 4 bits only two bits are used - 0x80 and 0x10. So you should
probably use mask_keycode with 0x47800000 instead of mask_keycode =3D
0x7f80000. Or even smaller mask. Include only bits which change the
values, nothing more.



--=-q4yeFoY5BmWgL41sy8j5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?koi8-r?Q?=FC=D4=C1?= =?koi8-r?Q?_=DE=C1=D3=D4=D8?=
	=?koi8-r?Q?_=D3=CF=CF=C2=DD=C5=CE=C9=D1?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=C1=CE=C1?=
	=?koi8-r?Q?_=C3=C9=C6=D2=CF=D7=CF=CA?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=D8=C0?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBGQrhJLCDh4YwOt9kRAtYfAKCpUe6ULsecQ0YNIqIzXpCiSdzsJQCfat5J
nBfggRIOCqpW5gPY3DkXCmY=
=oYht
-----END PGP SIGNATURE-----

--=-q4yeFoY5BmWgL41sy8j5--

