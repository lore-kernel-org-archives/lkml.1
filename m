Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZBJHcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZBJHcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZBJHcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:32:10 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:34349 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZBJHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:32:09 -0500
Date: Tue, 10 Feb 2009 08:01:47 +0100
From: Nico Schottelius <nico-linux-20090209@schottelius.org>
To: Nico Schottelius <nico-linux-20090209@schottelius.org>,
       Linux Next Mailing List <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: X200: Resume and iwlwifi on 2.6.29-rc4-ikn-00001-gd5b5623
Message-ID: <20090210070147.GA4684@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090209@schottelius.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
References: <20090209093507.GA27678@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20090209093507.GA27678@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00001-gd5b5623 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Good morning!

Summary on the X200:
- First resume after suspend takes 20 seconds
- Further resumes work fine
- wlan works *before* first suspend and wakeup
- after that the same happens as on 2.6.29-rc3-ikn-00697-gae1a25d:
  the device refuses to come up with the message
  "iwlagn: Could not load the INST uCode section" and
  "iwlagn: Unable to set up bootstrap uCode: -110"

Dmesg before suspend:
Feb  9 21:18:06 ikn kernel: [    9.535291] iwlagn: Intel(R) Wireless WiFi L=
ink AGN driver for Linux, 1.3.27ks
Feb  9 21:18:06 ikn kernel: [    9.535469] iwlagn: Copyright(c) 2003-2008 I=
ntel Corporation
Feb  9 21:18:06 ikn kernel: [    9.535653] iwlagn 0000:03:00.0: PCI INT A -=
> GSI 17 (level, low) -> IRQ 17
Feb  9 21:18:06 ikn kernel: [    9.535774] iwlagn 0000:03:00.0: setting lat=
ency timer to 64
Feb  9 21:18:06 ikn kernel: [    9.535807] iwlagn: Detected Intel Wireless =
WiFi Link 5300AGN REV=3D0x24
Feb  9 21:18:06 ikn kernel: [    9.554784] iwlagn: Tunable channels: 13 802=
=2E11bg, 24 802.11a channels
Feb  9 21:18:06 ikn kernel: [    9.555464] iwlagn 0000:03:00.0: PCI INT A d=
isabled
Feb  9 21:18:06 ikn kernel: [    9.563121] wmaster0 (iwlagn): not using net=
_device_ops yet
Feb  9 21:18:06 ikn kernel: [    9.563784] phy0: Selected rate control algo=
rithm 'iwl-agn-rs'
Feb  9 21:18:06 ikn kernel: [    9.857164] wlan0 (iwlagn): not using net_de=
vice_ops yet
Feb  9 21:18:20 ikn kernel: [   62.784153] iwlagn 0000:03:00.0: PCI INT A -=
> GSI 17 (level, low) -> IRQ 17
Feb  9 21:18:20 ikn kernel: [   62.784381] iwlagn 0000:03:00.0: restoring c=
onfig space at offset 0x1 (was 0x100102, writing 0x100106)
Feb  9 21:18:20 ikn kernel: [   62.784495] iwlagn 0000:03:00.0: irq 29 for =
MSI/MSI-X
Feb  9 21:18:20 ikn kernel: [   62.784580] iwlagn 0000:03:00.0: firmware: r=
equesting iwlwifi-5000-1.ucode
Feb  9 21:18:20 ikn kernel: [   62.936982] iwlagn loaded firmware version 5=
=2E4.1.16
Feb  9 21:18:20 ikn kernel: [   62.938427] iwlagn: Radio disabled by HW RF =
Kill switch
Feb  9 21:18:20 ikn kernel: [   62.950596] ADDRCONF(NETDEV_UP): wlan0: link=
 is not ready
Feb  9 21:19:21 ikn kernel: [  124.407490] wlan0: direct probe to AP 00:14:=
6c:67:9c:32 try 1
Feb  9 21:19:21 ikn kernel: [  124.410724] wlan0 direct probe responded
Feb  9 21:19:21 ikn kernel: [  124.410730] wlan0: authenticate with AP 00:1=
4:6c:67:9c:32
Feb  9 21:19:21 ikn kernel: [  124.412782] wlan0: authenticated
Feb  9 21:19:21 ikn kernel: [  124.412787] wlan0: associate with AP 00:14:6=
c:67:9c:32
Feb  9 21:19:21 ikn kernel: [  124.420641] wlan0: RX AssocResp from 00:14:6=
c:67:9c:32 (capab=3D0x601 status=3D0 aid=3D9)
Feb  9 21:19:21 ikn kernel: [  124.420647] wlan0: associated
Feb  9 21:19:21 ikn kernel: [  124.425527] ADDRCONF(NETDEV_CHANGE): wlan0: =
link becomes ready
Feb  9 21:19:32 ikn kernel: [  134.452077] wlan0: no IPv6 routers present

Dmesg after suspend:
[  569.004130] iwlagn: Could not load the INST uCode section
[  569.004135] iwlagn: Unable to set up bootstrap uCode: -110
[  574.004128] iwlagn: Could not load the INST uCode section
[  574.004132] iwlagn: Unable to set up bootstrap uCode: -110
[  579.004139] iwlagn: Could not load the INST uCode section
[  579.004143] iwlagn: Unable to set up bootstrap uCode: -110
[  584.004128] iwlagn: Could not load the INST uCode section
[  584.004132] iwlagn: Unable to set up bootstrap uCode: -110
[  589.004139] iwlagn: Could not load the INST uCode section
[  589.004143] iwlagn: Unable to set up bootstrap uCode: -110
[  589.013376] iwlagn: Unable to initialize device after 5 attempts.
[  589.013469] iwlagn 0000:03:00.0: PCI INT A disabled
[  589.014080] sd 0:0:0:0: [sda] Starting disk
[  590.528142] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[  590.776137] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[  591.032124] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[  591.183383] pci 0000:00:02.0: power state changed by ACPI to D0
[  591.183416] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[  591.183582] pci 0000:00:02.0: power state changed by ACPI to D0
[  591.183594] pci 0000:00:02.0: setting latency timer to 64
[  591.200209] Restarting tasks ... done.
[  592.305888] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[  592.629437] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[  592.647485] input: TPPS/2 IBM TrackPoint as /class/input/input11
[  593.200148] wlan0: No ProbeResp from current AP 00:14:6c:67:9c:32 - assu=
me out of range
[  611.582358] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
[  611.780126] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 2
[  611.980122] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 3
[  612.180163] wlan0: direct probe to AP 00:14:6c:67:9c:32 timed out

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmRJlsACgkQuL75KpiFGIz7igCg6dWPpMjy3mJhCQ9HElKuA5bb
KbIAoN11gnd7CQ8MXqgWQmXiP/yBDvBK
=Dfq4
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
