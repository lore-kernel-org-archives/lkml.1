Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZF3UKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZF3UKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZF3UJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:09:58 -0400
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:53620 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752540AbZF3UJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:09:57 -0400
From: Arseniy Lartsev <ars3n@yandex.ru>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: PROBLEM: USB ACM device does not work
Date: Wed, 1 Jul 2009 00:09:44 +0400
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc1-git3-0.1-default; KDE/4.1.3; i686; ; )
Cc: USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <200906282229.35713.ars3n@yandex.ru> <200906291735.23024.ars3n@yandex.ru> <200906300922.04257.oliver@neukum.org>
In-Reply-To: <200906300922.04257.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4185237.WugpqnJuUy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907010009.51237.ars3n@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4185237.WugpqnJuUy
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 June 2009 11:22:04 Oliver Neukum wrote:
> Yet, your device shows bulk endpoints. Please enable DEBUG in cdc-acm.c
> and recompile with CONFIG_USB_DEBUG.

I've recompiled four modules usbcore, ehci_hcd, ohci_hcd and cdc-acm with -=
DDEBUG.
Here is kernel log:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D De=
vice plugged in =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Jun 30 23:58:34 noteb00k kernel: usb usb1: usb resume
Jun 30 23:58:34 noteb00k kernel: ehci_hcd 0000:00:03.3: resume root hub
Jun 30 23:58:35 noteb00k kernel: ehci_hcd 0000:00:03.3: port 5 low speed --=
> companion
Jun 30 23:58:35 noteb00k kernel: ehci_hcd 0000:00:03.3: GetStatus port 5 st=
atus 003002 POWER OWNER sig=3Dse0 CSC
Jun 30 23:58:35 noteb00k kernel: hub 1-0:1.0: hub_resume                   =
                                  =20
Jun 30 23:58:35 noteb00k kernel: usb usb2: usb resume                      =
                                  =20
Jun 30 23:58:35 noteb00k kernel: hub 1-0:1.0: state 7 ports 6 chg 0000 evt =
0000                              =20
Jun 30 23:58:35 noteb00k kernel: ohci_hcd 0000:00:03.0: wakeup root hub    =
                                  =20
Jun 30 23:58:35 noteb00k kernel: hub 2-0:1.0: hub_resume                   =
                                  =20
Jun 30 23:58:35 noteb00k kernel: ohci_hcd 0000:00:03.0: GetStatus roothub.p=
ortstatus [2] =3D 0x00010301 CSC LSDA PPS=20
CCS
Jun 30 23:58:35 noteb00k kernel: hub 2-0:1.0: port 3: status 0301 change 00=
01                                        =20
Jun 30 23:58:35 noteb00k kernel: hub 2-0:1.0: state 7 ports 3 chg 0008 evt =
0000                                      =20
Jun 30 23:58:35 noteb00k kernel: hub 2-0:1.0: port 3, status 0301, change 0=
000, 1.5 Mb/s                             =20
Jun 30 23:58:35 noteb00k kernel: ohci_hcd 0000:00:03.0: GetStatus roothub.p=
ortstatus [2] =3D 0x00100303 PRSC LSDA PPS=20
PES CCS                                                                    =
                                              =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: new low speed USB device using oh=
ci_hcd and address 5                       =20
Jun 30 23:58:35 noteb00k kernel: ohci_hcd 0000:00:03.0: GetStatus roothub.p=
ortstatus [2] =3D 0x00100303 PRSC LSDA PPS=20
PES CCS                                                                    =
                                              =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: skipped 4 descriptors after inter=
face                                       =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: config 1 interface 1 altsetting 0=
 endpoint 0x1 is Bulk; changing to=20
Interrupt
Jun 30 23:58:35 noteb00k kernel: usb 2-3: config 1 interface 1 altsetting 0=
 endpoint 0x81 is Bulk; changing to=20
Interrupt                                                                  =
                                                   =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: default language 0x0409          =
                                           =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: udev 5, busnum 2, minor =3D 132  =
                                             =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: New USB device found, idVendor=3D=
16c0, idProduct=3D05e1                         =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: New USB device strings: Mfr=3D1, =
Product=3D2, SerialNumber=3D0                    =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: Product: AVR910 USB Programmer   =
                                           =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: Manufacturer: PROTTOSS           =
                                           =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: uevent                           =
                                           =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: usb_probe_device                 =
                                           =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: configuration #1 chosen from 1 ch=
oice                                       =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: adding 2-3:1.0 (config #1, interf=
ace 0)                                     =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3:1.0: uevent                       =
                                           =20
Jun 30 23:58:35 noteb00k kernel: cdc_acm 2-3:1.0: usb_probe_interface      =
                                           =20
Jun 30 23:58:35 noteb00k kernel: cdc_acm 2-3:1.0: usb_probe_interface - got=
 id                                        =20
Jun 30 23:58:35 noteb00k kernel: cdc_acm 2-3:1.0: The data interface has sw=
itched endpoints                           =20
Jun 30 23:58:35 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: in=
terfaces are valid                         =20
Jun 30 23:58:35 noteb00k kernel: cdc_acm 2-3:1.0: ttyACM0: USB ACM device  =
                                           =20
Jun 30 23:58:35 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x22 val: 0x0 len: 0x0=20
result: 0                                                                  =
                                             =20
Jun 30 23:58:35 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x20 val: 0x0 len: 0x7=20
result: 7                                                                  =
                                             =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3: adding 2-3:1.1 (config #1, interf=
ace 1)                                     =20
Jun 30 23:58:35 noteb00k kernel: usb 2-3:1.1: uevent                       =
                                           =20
Jun 30 23:58:35 noteb00k kernel: hub 2-0:1.0: state 7 ports 3 chg 0000 evt =
0008                                       =20
Jun 30 23:58:38 noteb00k kernel: hub 1-0:1.0: hub_suspend                  =
                                           =20
Jun 30 23:58:38 noteb00k kernel: usb usb1: bus auto-suspend                =
                                           =20
Jun 30 23:58:38 noteb00k kernel: ehci_hcd 0000:00:03.3: suspend root hub   =
                                           =20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D ec=
ho -n S >/dev/ttyACM0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering acm_tty_open.
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x22 val: 0x3 len: 0x0=20
result: 0                                                                  =
                                             =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering acm_tty_write to write 1 bytes,     =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: Ge=
t 1 bytes...                               =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_write_start susp_count: 0                =20
Jun 30 23:58:44 noteb00k kernel: usb_sumbit_urb: failing due to non-positiv=
e interval   //
Jun 30 23:58:44 noteb00k kernel: usb_submit_urb: xfertype =3D 3 of 1/3     =
               // these were added by me
Jun 30 23:58:44 noteb00k kernel: xfertype is USB_ENDPOINT_XFER_INT         =
             //
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: us=
b_submit_urb(write bulk) failed: -22       =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering acm_rx_tasklet                      =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_rx_tasklet: ACM not ready                =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x22 val: 0x0 len: 0x0=20
result: 0                                                                  =
                                             =20
Jun 30 23:58:44 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_ctrl_irq - urb shutting down with=20
status: -2                                                                 =
                                                   =20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D ca=
t /dev/ttyACM0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Jun 30 23:58:54 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering acm_tty_open.
Jun 30 23:58:54 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x22 val: 0x3 len: 0x0=20
result: 0                                                                  =
                                             =20
Jun 30 23:58:54 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering acm_rx_tasklet                      =20
Jun 30 23:58:54 noteb00k kernel: usb_sumbit_urb: failing due to non-positiv=
e interval                                 =20
Jun 30 23:58:54 noteb00k kernel: usb_submit_urb: xfertype =3D 3 of 1/3     =
                                             =20
Jun 30 23:58:54 noteb00k kernel: xfertype is USB_ENDPOINT_XFER_INT         =
                                           =20
Jun 30 23:58:54 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: in=
put control lines: dcd- dsr- break- ring-=20
framing- parity- overrun-
Jun 30 23:58:54 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: di=
sconnected from network

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Te=
rminate cat with Ctrl+C =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Jun 30 23:58:58 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_control_msg: rq: 0x22 val: 0x0 len: 0x0=20
result: 0
Jun 30 23:58:58 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: ac=
m_ctrl_irq - urb shutting down with=20
status:-2

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D De=
vice unplugged =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Jun 30 23:59:08 noteb00k kernel: hub 2-0:1.0: state 7 ports 3 chg 0000 evt =
0008
Jun 30 23:59:08 noteb00k kernel: ohci_hcd 0000:00:03.0: GetStatus roothub.p=
ortstatus [2] =3D 0x00030300 PESC CSC LSDA=20
PPS
Jun 30 23:59:08 noteb00k kernel: hub 2-0:1.0: port 3, status 0300, change 0=
003, 1.5 Mb/s
Jun 30 23:59:08 noteb00k kernel: usb 2-3: USB disconnect, address 5
Jun 30 23:59:08 noteb00k kernel: usb 2-3: unregistering device
Jun 30 23:59:08 noteb00k kernel: usb 2-3: usb_disable_device nuking all URBs
Jun 30 23:59:08 noteb00k kernel: usb 2-3: unregistering interface 2-3:1.0
Jun 30 23:59:08 noteb00k kernel: /w/work/lesh/research/driver/cdc-acm.c: En=
tering stop_data_traffic
Jun 30 23:59:08 noteb00k kernel: usb 2-3:1.0: uevent
Jun 30 23:59:08 noteb00k kernel: usb 2-3: unregistering interface 2-3:1.1
Jun 30 23:59:08 noteb00k kernel: usb 2-3:1.1: uevent
Jun 30 23:59:08 noteb00k kernel: usb 2-3: uevent
Jun 30 23:59:08 noteb00k kernel: hub 2-0:1.0: debounce: port 3: total 100ms=
 stable 100ms status 0x300
Jun 30 23:59:09 noteb00k kernel: ohci_hcd 0000:00:03.0: auto-stop root hub
Jun 30 23:59:11 noteb00k kernel: hub 2-0:1.0: hub_suspend
Jun 30 23:59:11 noteb00k kernel: usb usb2: bus auto-suspend
Jun 30 23:59:11 noteb00k kernel: ohci_hcd 0000:00:03.0: suspend root hub


--nextPart4185237.WugpqnJuUy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iJwEAAECAAYFAkpKcQ8ACgkQIHDkq2F9exaAsgP9GJwKasBxscJzd114RB95x3JC
Q+hCFB9qkq3xMo7iHEai0ooh8gWXGMq78sX18MOiRsyL7/8doJoZFq2Z12H/o4k+
Kq8aMdTTVxFYbbARmBrf/54grdVC+w+hS9e6PF5wKtdtGMkf80rXOAX/qHq2uc73
QtZhFzEPZ7MrK7gFC+U=
=eemf
-----END PGP SIGNATURE-----

--nextPart4185237.WugpqnJuUy--
