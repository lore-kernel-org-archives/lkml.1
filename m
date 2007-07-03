Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXGCUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXGCUK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbXGCUKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:10:48 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:50098 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634AbXGCUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:10:47 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Ni@m" <niam.niam@gmail.com>
Subject: Re: [PATCH] for NIKON D50 as UMS
Date: Tue, 3 Jul 2007 23:10:32 +0300
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <a9e22dff0707031303i30c08439t3cc48fb1b95f29b8@mail.gmail.com>
In-Reply-To: <a9e22dff0707031303i30c08439t3cc48fb1b95f29b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4113719.WcnmsOvY7Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707032310.33106.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4113719.WcnmsOvY7Z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

03 Tem 2007 Sal tarihinde, Ni@m =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=B1:=
=20
> This short patch allows NIKON D50 to be mounted as UMS on 2.6.22-rc7,
> some previous kernels...
>
>
> --- linux-2.6.22-rc7/drivers/usb/storage/unusual_devs.h 2007-07-03
> 22:54:23.000000000 +0300
> +++ linux-2.6.22-rc7-niam/drivers/usb/storage/unusual_devs.h
> 2007-07-03 22:35:39.000000000 +0300
> @@ -313,6 +313,13 @@
>                 US_SC_DEVICE, US_PR_DEVICE,NULL,
>                 US_FL_NOT_LOCKABLE ),
>
> +/* Reported by Niam <niam.niam@gmail.com> */
> +UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
> +               "NIKON",
> +               "NIKON DSC D50",
> +               US_SC_DEVICE, US_PR_DEVICE, NULL,
> +               US_FL_FIX_CAPACITY),
> +
>  /* Reported by Andreas Bockhold <andreas@bockionline.de> */
>  UNUSUAL_DEV(  0x04b0, 0x0405, 0x0100, 0x0100,
>                 "NIKON",

Hmm i have NIKON D50 also and it works here without a problem with Linus's=
=20
current git.=20

=2E..
caglar@zangetsu ~ $ mount
/dev/sda3 on / type ext3 (rw,noatime,user_xattr)
proc on /proc type proc (rw,noexec,nosuid)
sysfs on /sys type sysfs (rw)
usbfs on /proc/bus/usb type usbfs (rw)
tmpfs on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
securityfs on /sys/kernel/security type securityfs (rw)
/dev/sdc1 on /media/sdc1 type vfat=20
(rw,nosuid,nodev,noatime,uhelper=3Dhal,flush,uid=3D1000,utf8,shortname=3Dmi=
xed)

caglar@zangetsu ~ $ uname -a
Linux zangetsu 2.6.22-rc7-CFS-v18 #32 SMP Tue Jul 3 09:29:55 EEST 2007 i686=
=20
Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz GNU/Linux

[   43.040002] ipw3945: Detected geography ABG (13 802.11bg channels, 23=20
802.11a channels)
[   46.140489] APIC error on CPU1: 00(40)
[   46.140492] APIC error on CPU0: 00(40)
[  134.156403] NET: Registered protocol family 17
[  153.610600] FAT: utf8 is not a recommended IO charset for FAT filesystem=
s,=20
filesystem will be case sensitive!
[ 5376.491701] usb 5-1: new high speed USB device using ehci_hcd and addres=
s 6
[ 5376.607589] usb 5-1: configuration #1 chosen from 1 choice
[ 5376.607970] scsi7 : SCSI emulation for USB Mass Storage devices
[ 5376.608453] usb-storage: device found at 6
[ 5376.608472] usb-storage: waiting for device to settle before scanning
[ 5381.601547] scsi 7:0:0:0: Direct-Access     NIKON    D50              1.=
00=20
PQ: 0 ANSI: 2
[ 5381.602885] sd 7:0:0:0: [sdc] 2012161 512-byte hardware sectors (1030 MB)
[ 5381.603383] sd 7:0:0:0: [sdc] Write Protect is off
[ 5381.603390] sd 7:0:0:0: [sdc] Mode Sense: 0f 00 00 00
[ 5381.603394] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 5381.605133] sd 7:0:0:0: [sdc] 2012161 512-byte hardware sectors (1030 MB)
[ 5381.605617] sd 7:0:0:0: [sdc] Write Protect is off
[ 5381.605624] sd 7:0:0:0: [sdc] Mode Sense: 0f 00 00 00
[ 5381.605628] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 5381.605633]  sdc: sdc1
[ 5381.610048] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[ 5381.610951] usb-storage: device scan complete
[ 5385.190375] FAT: utf8 is not a recommended IO charset for FAT filesystem=
s,=20
filesystem will be case sensitive!
=2E..

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart4113719.WcnmsOvY7Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGiq05y7E6i0LKo6YRAnpAAKCzmYrG9O5nFyviR+dzD3RfowutowCfcgTm
eoIGpuBou50eIa3Zd1Flfek=
=hFpQ
-----END PGP SIGNATURE-----

--nextPart4113719.WcnmsOvY7Z--
