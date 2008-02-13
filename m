Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYBMOMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYBMOMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYBMOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:12:15 -0500
Received: from os.eurotux.com ([216.75.63.6]:34359 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYBMOMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:12:13 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 09:12:13 EST
Date: Wed, 13 Feb 2008 14:05:27 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: linux-kernel@vger.kernel.org
Subject: sysfs: duplicate filename 'card0' can not be created
Message-ID: <20080213140527.GA31014@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello,

Is this known? I got the error while connecting usb headphones, running
vanilla 2.6.24.

Error:

[.361992] usb 1-1.3: new full speed USB device using ehci_hcd and address 13
[.448232] usb 1-1.3: configuration #1 chosen from 1 choice
[.506787] sysfs: duplicate filename 'card0' can not be created
[.506796] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[.506802] Pid: 794, comm: khubd Not tainted 2.6.24lcfs1 #1
[.506819]  [<c04a07cd>] sysfs_add_one+0x54/0xb7
[.506835]  [<c04a1415>] sysfs_create_link+0xbe/0x109
[.506846]  [<c05db991>] device_add+0x132/0x447
[.506856]  [<c057e9ba>] kobject_init+0x27/0x37
[.506866]  [<c05dbf12>] device_create+0x77/0x97
[.506873]  [<c0611fa1>] snd_card_register+0x3f/0x254
[.506883]  [<f083fa71>] usb_driver_claim_interface+0x6b/0x86 [usbcore]
[.506944]  [<f09b7cbb>] usb_audio_probe+0x6c7/0x76e [snd_usb_audio]
[.506990]  [<f083f960>] usb_probe_interface+0xa2/0xda [usbcore]
[.507010]  [<c05dd14b>] driver_sysfs_add+0x36/0x53
[.507018]  [<c05dd2ab>] driver_probe_device+0xdd/0x15a
[.507025]  [<c0688f9a>] klist_next+0x50/0x82
[.507032]  [<c05dd328>] __device_attach+0x0/0x5
[.507037]  [<c05dc7ce>] bus_for_each_drv+0x32/0x58
[.507045]  [<c05dd3a5>] device_attach+0x5d/0x70
[.507049]  [<c05dd328>] __device_attach+0x0/0x5
[.507055]  [<c05dc74f>] bus_attach_device+0x26/0x73
[.507062]  [<c05dbabc>] device_add+0x25d/0x447
[.507073]  [<f083e316>] usb_set_configuration+0x3f6/0x469 [usbcore]
[.507099]  [<f0844ba7>] generic_probe+0x50/0x91 [usbcore]
[.507125]  [<f083f763>] usb_probe_device+0x32/0x37 [usbcore]
[.507142]  [<c05dd2ab>] driver_probe_device+0xdd/0x15a
[.507148]  [<c0688f9a>] klist_next+0x50/0x82
[.507154]  [<c05dd328>] __device_attach+0x0/0x5
[.507159]  [<c05dc7ce>] bus_for_each_drv+0x32/0x58
[.507167]  [<c05dd3a5>] device_attach+0x5d/0x70
[.507172]  [<c05dd328>] __device_attach+0x0/0x5
[.507177]  [<c05dc74f>] bus_attach_device+0x26/0x73
[.507184]  [<c05dbabc>] device_add+0x25d/0x447
[.507195]  [<f0839c0f>] usb_new_device+0x41/0x7e [usbcore]
[.507217]  [<f083ad51>] hub_thread+0x6b6/0xa93 [usbcore]
[.507243]  [<c042fc93>] autoremove_wake_function+0x0/0x35
[.507253]  [<c06895dc>] schedule+0x1e2/0x22e
[.507258]  [<f083a69b>] hub_thread+0x0/0xa93 [usbcore]
[.507276]  [<c042fbd9>] kthread+0x36/0x5d
[.507280]  [<c042fba3>] kthread+0x0/0x5d
[.507285]  [<c0404a1b>] kernel_thread_helper+0x7/0x10
[.507294]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[.511876] input: USB Audio as /devices/pci0000:00/0000:00:1e.0/0000:02:04.2=
/usb1/1-1/1-1.3/1-1.3:1.3/input/input7
[.537041] input: USB HID v1.00 Device [USB Audio] on usb-0000:02:04.2-1.3

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHsvkninSul6a7oB8RApwsAJ4wMcnHhYztgDnE433DlFC1dL/DuACfbEXb
ICkuI/RSpOL3HRJgGZImYlI=
=9VQ/
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
