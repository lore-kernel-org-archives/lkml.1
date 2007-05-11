Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXEKIA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXEKIA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXEKIAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:00:22 -0400
Received: from smtp2.yandex.ru ([213.180.200.18]:57333 "EHLO smtp2.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbXEKIAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:00:21 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2007 04:00:21 EDT
Subject: Re: [PATCH] v4l: saa7134: support ir-remote for 10moons TM300
From: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
To: Tony Wan <wankai@sjtu.org>
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178852562.7216.4.camel@wankai.sjtu.org>
References: <1178852562.7216.4.camel@wankai.sjtu.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bo8pdjyF+HPI6Erxsp6+"
Date: Fri, 11 May 2007 11:51:23 +0400
Message-Id: <1178869883.7163.2.camel@gnome.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 (2.9.5-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bo8pdjyF+HPI6Erxsp6+
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=D0=92 =D0=9F=D1=82=D0=BD, 11/05/2007 =D0=B2 11:02 +0800, Tony Wan =D0=BF=
=D0=B8=D1=88=D0=B5=D1=82:
> Enable the IR-remote of the 10moons TM300 card and add the key-codes for
> it's remote.=20
>=20
> It has been tested using lirc. All the key codes are accepted.
>=20
> Signed-off-by: Tony Wan <wankai@sjtu.org>
> ---
>  drivers/media/common/ir-keymaps.c           |   69
> +++++++++++++++++++++++++++
>  drivers/media/video/saa7134/saa7134-cards.c |    1 +
>  drivers/media/video/saa7134/saa7134-input.c |    6 ++
>  include/media/ir-common.h                   |    1 +
>  4 files changed, 77 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/media/common/ir-keymaps.c
> b/drivers/media/common/ir-keymaps.c
> index cbd1184..5aa293e 100644
> --- a/drivers/media/common/ir-keymaps.c
> +++ b/drivers/media/common/ir-keymaps.c
> @@ -1783,3 +1783,72 @@ IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE] =
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
> +	[ 0x24 ] =3D KEY_ARCHIVE,         // Time shifting
> +	[ 0x20 ] =3D KEY_SWITCHVIDEOMODE, // Selcect source
> +
> +	[ 0x3a ] =3D KEY_RECORD,          // Record
> +	[ 0x22 ] =3D KEY_PLAY,            // Play/Pause
> +	[ 0x25 ] =3D KEY_STOP,            // Stop
> +	[ 0x23 ] =3D KEY_CAMERA,          // Snapshot
> +
> +	[ 0x28 ] =3D KEY_BACK,            // Backward <<
> +	[ 0x2a ] =3D KEY_FORWARD,         // Forward >>
> +	[ 0x29 ] =3D KEY_PREVIOUS,        // Back |<<
> +	[ 0x2b ] =3D KEY_NEXT,            // End >>|
> +
> +	[ 0x2c ] =3D KEY_PROGRAM,         // Multi-view
> +	[ 0x2d ] =3D KEY_AUDIO,           // Audio Tracks
> +	[ 0x2e ] =3D KEY_SOUND,           // Sound
> +	[ 0x2f ] =3D KEY_SUBTITLE,        // Subtitles
> +
> +	[ 0x30 ] =3D KEY_TIME,            // Set timer
> +	[ 0x31 ] =3D KEY_CHANNEL,         // Stereo
> +	[ 0x32 ] =3D KEY_LANGUAGE,        // Language
> +	[ 0x33 ] =3D KEY_TEXT,            // Text
> +
> +	[ 0x39 ] =3D KEY_RED,             // RED
> +	[ 0x21 ] =3D KEY_GREEN,           // GREEN
> +	[ 0x27 ] =3D KEY_YELLOW,          // YELLOW
> +	[ 0x37 ] =3D KEY_BLUE,            // BLUE
> +};
> +
> +EXPORT_SYMBOL_GPL(ir_codes_10moonstm3);
> diff --git a/drivers/media/video/saa7134/saa7134-cards.c
> b/drivers/media/video/saa7134/saa7134-cards.c
> index 44f2077..5813509 100644
> --- a/drivers/media/video/saa7134/saa7134-cards.c
> +++ b/drivers/media/video/saa7134/saa7134-cards.c
> @@ -4368,6 +4368,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
>  	case SAA7134_BOARD_AVERMEDIA_A16AR:
>  	case SAA7134_BOARD_ENCORE_ENLTV:
>  	case SAA7134_BOARD_ENCORE_ENLTV_FM:
> +	case SAA7134_BOARD_10MOONSTVMASTER3:
>  		dev->has_remote =3D SAA7134_REMOTE_GPIO;
>  		break;
>  	case SAA7134_BOARD_FLYDVBS_LR300:
> diff --git a/drivers/media/video/saa7134/saa7134-input.c
> b/drivers/media/video/saa7134/saa7134-input.c
> index c0de37e..c87755b 100644
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -333,6 +333,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  		mask_keyup   =3D 0x040000;
>  		polling      =3D 50; // ms
>  		break;
> +	case SAA7134_BOARD_10MOONSTVMASTER3:
> +		ir_codes     =3D ir_codes_10moonstm3;
> +		mask_keycode =3D 0x4f80000;
> +		mask_keyup   =3D 0x8000000;
> +		polling      =3D 50; //ms
> +		break;
>  	}
>  	if (NULL =3D=3D ir_codes) {
>  		printk("%s: Oops: IR config error [card=3D%d]\n",
> diff --git a/include/media/ir-common.h b/include/media/ir-common.h
> index 9807a7c..4e4d207 100644
> --- a/include/media/ir-common.h
> +++ b/include/media/ir-common.h
> @@ -140,6 +140,7 @@ extern IR_KEYTAB_TYPE
> ir_codes_budget_ci_old[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_asus_pc39[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_encore_enltv[IR_KEYTAB_SIZE];
>  extern IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE];
> +extern IR_KEYTAB_TYPE ir_codes_10moonstm3[IR_KEYTAB_SIZE];
> =20
>  #endif
> =20

Great, now another correction, sorry for not noticing it before. With
correction of bit 0x4 -> 0x2 your remote is exactly the same as=20
ir_codes_encore_enltv so probably there is sense just to reuse old
codes. Elencore mask should be reduced too. I also wonder aren't we
talking about the same card here.




--=-bo8pdjyF+HPI6Erxsp6+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?koi8-r?Q?=FC=D4=C1?= =?koi8-r?Q?_=DE=C1=D3=D4=D8?=
	=?koi8-r?Q?_=D3=CF=CF=C2=DD=C5=CE=C9=D1?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=C1=CE=C1?=
	=?koi8-r?Q?_=C3=C9=C6=D2=CF=D7=CF=CA?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=D8=C0?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBGRCB7LCDh4YwOt9kRAqKVAKC4up649X617OuLSoZqbrPAEYxhcgCggl3w
nsUCckmMZJES1oDPsD2E4cs=
=auQ4
-----END PGP SIGNATURE-----

--=-bo8pdjyF+HPI6Erxsp6+--

