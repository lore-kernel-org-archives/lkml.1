Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZKGVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZKGVd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZKGVdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:33:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34164 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbZKGVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:33:21 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rdXWMmmMVDKhe3BvzBy5"
Date: Sat, 07 Nov 2009 21:33:21 +0000
Message-ID: <1257629601.15927.361.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 00/75] Declare MODULE_FIRMWARE where necessary
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rdXWMmmMVDKhe3BvzBy5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Drivers that must load 'firmware' into the devices they drive should
declare the names of the files they will request, using the
MODULE_FIRMWARE() macro.  This enables other tools to discover these
dependencies statically, and warn the user if firmware files are
missing.

This patch series based on linux-next adds these declarations for
drivers that do not already have them.

Ben.

Ben Hutchings (75):
  netx: declare MODULE_FIRMWARE
  solos-pci: declare MODULE_FIRMWARE
  btmrvl-sdio: declare MODULE_FIRMWARE
  cyclades: declare MODULE_FIRMWARE
  ip2: declare MODULE_FIRMWARE
  isicom: declare MODULE_FIRMWARE
  moxa: declare MODULE_FIRMWARE
  ambassador: declare MODULE_FIRMWARE
  speedfax: declare MODULE_FIRMWARE
  V4L/DVB: declare MODULE_FIRMWARE for modules using XC2028 and XC3028L
    tuners
  xc5000: declare MODULE_FIRMWARE
  dvb-usb: declare MODULE_FIRMWARE
  af90013: declare MODULE_FIRMWARE
  bcm3510: declare MODULE_FIRMWARE
  cx24416: declare MODULE_FIRMWARE
  drx397xD: declare MODULE_FIRMWARE
  nxt200x: declare MODULE_FIRMWARE
  or51132: declare MODULE_FIRMWARE
  or51211: declare MODULE_FIRMWARE
  sp8870: declare MODULE_FIRMWARE
  sp887x: declare MODULE_FIRMWARE
  tda10048: declare MODULE_FIRMWARE
  tda1004x: declare MODULE_FIRMWARE
  smsmdtv/smsusb: declare MODULE_FIRMWARE
  dvb-ttpci/av7110: declare MODULE_FIRMWARE
  ttusb-dec: declare MODULE_FIRMWARE
  bttv: declare MODULE_FIRMWARE
  cpia2: declare MODULE_FIRMWARE
  cx18: declare MODULE_FIRMWARE
  cx23885: declare MODULE_FIRMWARE
  cx25840: declare MODULE_FIRMWARE
  cx88-blackbird: declare MODULE_FIRMWARE
  dabusb: declare MODULE_FIRMWARE
  ivtv: declare MODULE_FIRMWARE
  pvrusb2: declare MODULE_FIRMWARE
  s2255drv: declare MODULE_FIRMWARE
  saa7164: declare MODULE_FIRMWARE
  iwmc3200top: declare MODULE_FIRMWARE
  bnx2x: declare MODULE_FIRMWARE
  cxgb3: declare MODULE_FIRMWARE
  irda-usb: declare MODULE_FIRMWARE
  myri10ge: declare MODULE_FIRMWARE
  spider-net: declare MODULE_FIRMWARE
  tms380tr: declare MODULE_FIRMWARE
  at76c50x-usb: declare MODULE_FIRMWARE
  atmel: declare MODULE_FIRMWARE
  ipw2100: declare MODULE_FIRMWARE
  ipw2200: declare MODULE_FIRMWARE
  iwmc3200wifi: declare MODULE_FIRMWARE
  libertas: declare MODULE_FIRMWARE
  libertas_tf_usb: declare MODULE_FIRMWARE
  mwl8k: declare MODULE_FIRMWARE
  orinoco: declare MODULE_FIRMWARE
  prism54: declare MODULE_FIRMWARE
  wl12xx: declare MODULE_FIRMWARE
  zd1201: declare MODULE_FIRMWARE
  zd1211rw: declare MODULE_FIRMWARE
  pcnet-cs: declare MODULE_FIRMWARE
  serial-cs: declare MODULE_FIRMWARE
  bfa: declare MODULE_FIRMWARE
  icom: declare MODULE_FIRMWARE
  comedi/jr3_pci: declare MODULE_FIRMWARE
  go7007: declare MODULE_FIRMWARE
  rtl8192e: declare MODULE_FIRMWARE
  rtl8192su: declare MODULE_FIRMWARE
  sep: include driver name in firmware filenames
  sep: declare MODULE_FIRMWARE
  slicoss: declare MODULE_FIRMWARE
  prism2-usb: declare MODULE_FIRMWARE
  cxacru: declare MODULE_FIRMWARE
  ueagle-atm: declare MODULE_FIRMWARE
  isight-firmware: declare MODULE_FIRMWARE
  keyspan-pda: declare MODULE_FIRMWARE
  metronomefb: declare MODULE_FIRMWARE
  snd-aica: declare MODULE_FIRMWARE

 drivers/atm/ambassador.c                       |    1 +
 drivers/atm/solos-pci.c                        |    3 ++
 drivers/bluetooth/btmrvl_sdio.c                |    2 +
 drivers/char/cyclades.c                        |    1 +
 drivers/char/ip2/ip2main.c                     |    2 +
 drivers/char/isicom.c                          |    5 ++++
 drivers/char/moxa.c                            |    3 ++
 drivers/isdn/hardware/mISDN/speedfax.c         |    1 +
 drivers/media/common/tuners/xc5000.c           |    1 +
 drivers/media/dvb/dvb-usb/a800.c               |    1 +
 drivers/media/dvb/dvb-usb/af9005.c             |    1 +
 drivers/media/dvb/dvb-usb/af9015.c             |    1 +
 drivers/media/dvb/dvb-usb/cxusb.c              |    3 ++
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |    2 +
 drivers/media/dvb/dvb-usb/dibusb-mb.c          |    4 +++
 drivers/media/dvb/dvb-usb/digitv.c             |    1 +
 drivers/media/dvb/dvb-usb/dtt200u.c            |    5 ++++
 drivers/media/dvb/dvb-usb/dw2102.c             |    4 +++
 drivers/media/dvb/dvb-usb/gp8psk.c             |    1 +
 drivers/media/dvb/dvb-usb/m920x.c              |    4 +++
 drivers/media/dvb/dvb-usb/nova-t-usb2.c        |    1 +
 drivers/media/dvb/dvb-usb/opera1.c             |    1 +
 drivers/media/dvb/dvb-usb/ttusb2.c             |    2 +
 drivers/media/dvb/dvb-usb/umt-010.c            |    1 +
 drivers/media/dvb/dvb-usb/vp702x.c             |    1 +
 drivers/media/dvb/dvb-usb/vp7045.c             |    1 +
 drivers/media/dvb/frontends/af9013.c           |    1 +
 drivers/media/dvb/frontends/bcm3510.c          |    1 +
 drivers/media/dvb/frontends/cx24116.c          |    2 +-
 drivers/media/dvb/frontends/drx397xD.c         |    7 +++--
 drivers/media/dvb/frontends/drx397xD_fw.h      |    4 +-
 drivers/media/dvb/frontends/nxt200x.c          |    2 +
 drivers/media/dvb/frontends/or51132.c          |    2 +
 drivers/media/dvb/frontends/or51211.c          |    1 +
 drivers/media/dvb/frontends/sp8870.c           |    1 +
 drivers/media/dvb/frontends/sp887x.c           |    1 +
 drivers/media/dvb/frontends/tda10048.c         |    1 +
 drivers/media/dvb/frontends/tda1004x.c         |    2 +
 drivers/media/dvb/siano/sms-cards.c            |    4 +++
 drivers/media/dvb/siano/smscoreapi.c           |    7 ++++++
 drivers/media/dvb/siano/smsusb.c               |    4 +++
 drivers/media/dvb/ttpci/av7110.c               |    1 +
 drivers/media/dvb/ttusb-dec/ttusb_dec.c        |    3 ++
 drivers/media/video/bt8xx/bttv-cards.c         |    2 +
 drivers/media/video/cpia2/cpia2_core.c         |    2 +
 drivers/media/video/cx18/cx18-av-firmware.c    |    1 +
 drivers/media/video/cx18/cx18-driver.c         |    1 +
 drivers/media/video/cx18/cx18-dvb.c            |    2 +
 drivers/media/video/cx18/cx18-firmware.c       |    3 ++
 drivers/media/video/cx23885/cx23885-417.c      |    1 +
 drivers/media/video/cx23885/cx23885-dvb.c      |    3 ++
 drivers/media/video/cx25840/cx25840-firmware.c |    3 ++
 drivers/media/video/cx88/cx88-blackbird.c      |    1 +
 drivers/media/video/cx88/cx88-cards.c          |    2 +
 drivers/media/video/dabusb.c                   |    2 +
 drivers/media/video/em28xx/em28xx-cards.c      |    3 ++
 drivers/media/video/ivtv/ivtv-driver.c         |    1 +
 drivers/media/video/ivtv/ivtv-firmware.c       |    3 ++
 drivers/media/video/pvrusb2/pvrusb2-devattr.c  |    4 +++
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |    1 +
 drivers/media/video/s2255drv.c                 |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c    |    2 +
 drivers/media/video/saa7164/saa7164-fw.c       |    2 +
 drivers/misc/iwmc3200top/fw-download.c         |    2 +
 drivers/net/bnx2x_main.c                       |   27 ++++++++++++--------=
---
 drivers/net/cxgb3/common.h                     |    8 ++----
 drivers/net/cxgb3/cxgb3_main.c                 |   25 ++++++++++++++------=
--
 drivers/net/irda/irda-usb.c                    |    3 ++
 drivers/net/myri10ge/myri10ge.c                |    4 +++
 drivers/net/netx-eth.c                         |    3 ++
 drivers/net/pcmcia/pcnet_cs.c                  |    7 ++++++
 drivers/net/spider_net.c                       |    1 +
 drivers/net/tokenring/tms380tr.c               |    2 +
 drivers/net/wireless/at76c50x-usb.c            |    8 +++++++
 drivers/net/wireless/atmel.c                   |   16 ++++++++++++++
 drivers/net/wireless/ipw2x00/ipw2100.c         |    6 +++++
 drivers/net/wireless/ipw2x00/ipw2200.c         |    5 ++++
 drivers/net/wireless/iwmc3200wifi/sdio.c       |    3 ++
 drivers/net/wireless/libertas/if_cs.c          |    1 +
 drivers/net/wireless/libertas/if_sdio.c        |    6 +++++
 drivers/net/wireless/libertas/if_spi.c         |    4 +++
 drivers/net/wireless/libertas/if_usb.c         |    2 +
 drivers/net/wireless/libertas_tf/if_usb.c      |    2 +
 drivers/net/wireless/mwl8k.c                   |    3 ++
 drivers/net/wireless/orinoco/fw.c              |    6 +++++
 drivers/net/wireless/prism54/islpci_dev.c      |    3 ++
 drivers/net/wireless/wl12xx/wl1251_main.c      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c      |    1 +
 drivers/net/wireless/zd1201.c                  |    3 ++
 drivers/net/wireless/zd1211rw/zd_usb.c         |    7 ++++++
 drivers/scsi/bfa/bfad_fwimg.c                  |    2 +
 drivers/serial/icom.c                          |    4 ++-
 drivers/serial/serial_cs.c                     |   12 ++++++++++
 drivers/staging/comedi/drivers/jr3_pci.c       |    2 +
 drivers/staging/go7007/go7007-driver.c         |    2 +
 drivers/staging/go7007/go7007-usb.c            |    2 +
 drivers/staging/go7007/saa7134-go7007.c        |    1 +
 drivers/staging/rtl8192e/r819xE_firmware.c     |    4 +++
 drivers/staging/rtl8192su/r8192S_firmware.c    |    1 +
 drivers/staging/sep/sep_driver.c               |    7 ++++-
 drivers/staging/slicoss/slicoss.c              |    6 +++++
 drivers/staging/wlan-ng/prism2fw.c             |    1 +
 drivers/usb/atm/cxacru.c                       |    3 ++
 drivers/usb/atm/ueagle-atm.c                   |   23 ++++++++++++++++++++
 drivers/usb/misc/isight_firmware.c             |    2 +
 drivers/usb/serial/keyspan_pda.c               |    7 ++++++
 drivers/uwb/i1480/dfu/usb.c                    |    4 +++
 drivers/video/metronomefb.c                    |    1 +
 sound/sh/aica.c                                |    1 +
 109 files changed, 345 insertions(+), 37 deletions(-)



--=-rdXWMmmMVDKhe3BvzBy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASvXnnOe/yOyVhhEJAQKuFxAAgLF/ZHXYmiwYAlNkTryf+ZZBVURT5mbF
Y3h5iEFWhvovkUA3ASMCoCZZzs7lnK/LaGyE1woqwvMcBrGlD878Bad69hKB25c3
wQZKGZz5hE4LXFuRCmoRuFDLZ9zPrJeLVjA+0UhbBwH7x3S5gIW3Tibl35t0frWr
0KwrBw8JrCTP/up4gl5BTHbhcLyfxnNjQrXTo5xJxzWzFsfuyBlrycORCj3H4iPx
xHMpgv0Cq2WmeyojvlSnOKfAFum32SqWxpLBTqP5SJJuiH1LV+qYsHiv34GsM+sE
rLjlhFYnDRGVW8Y1M+njeWuD5KUy/wMJ1Z1Jj6dN+jAbuO2TQmeSxCxZl2hJMYXY
9/LgkblyPVfCL+Q1zGaZFl1pGbCmIaG6Az0GEHXgEURA4/6tqQua0gDcIKefQCA7
GTHoEeu9ePSdvoi5GNdCRP89teVgFPdOntGUq3fSCoYlysYeGqyxhOpblK92uSIC
6p0oeGQdwUKZtSO0GjXBDTHbgkGQ//6GpfQ7TsGt9k4KcrVG3IJ55vcHfmG32lrK
TkVsE2ImVjLfc86o8tRv9Fw5FiL3APRkkalVZDUB+2gW5JUyJmsBS3AzoT6Y6+I6
XzBnFo9SA5vB5XRkE28DtO+PLRaGq7Pkco3SA6UpQ+/gK4X/8WCWS0GNTkd43uMy
3Wea/pKQvYI=
=04A/
-----END PGP SIGNATURE-----

--=-rdXWMmmMVDKhe3BvzBy5--
