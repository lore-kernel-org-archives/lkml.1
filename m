Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbZE0Plq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbZE0Plq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZE0Plj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:41:39 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:39974 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZE0Pli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:41:38 -0400
Date: Wed, 27 May 2009 13:59:34 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: iwlwifi-BUGs: linux-next: Tree for May 27
Message-ID: <20090527115934.GB6790@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090527181536.4c453593.sfr@canb.auug.org.au> <20090527115325.GA6790@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Content-Disposition: inline
In-Reply-To: <20090527115325.GA6790@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7-next-20090527-06291-gc0f66c0 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico -telmich- Schottelius [Wed, May 27, 2009 at 01:53:25PM +0200]:
> Stephen Rothwell [Wed, May 27, 2009 at 06:15:36PM +1000]:
> > Changes since 20090526:
>=20
> Works on amd64 (x200), but reports some bugs.

And is still not able to connect to any ap:

[ 2939.433303] iwlagn 0000:03:00.0: PCI INT A disabled
[ 2939.476629] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27k
[ 2939.476633] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 2939.476802] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[ 2939.476835] iwlagn 0000:03:00.0: setting latency timer to 64
[ 2939.476906] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[ 2939.512432] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[ 2939.512512] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[ 2939.516822] phy1: Selected rate control algorithm 'iwl-agn-rs'
[ 2941.587468] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[ 2941.592879] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[ 2941.773363] Registered led device: iwl-phy1::radio
[ 2941.773425] Registered led device: iwl-phy1::assoc
[ 2941.773477] Registered led device: iwl-phy1::RX
[ 2941.773529] Registered led device: iwl-phy1::TX
[ 2941.806055] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2945.977060] wlan0: authenticate with AP 00:03:52:1c:18:71
[ 2945.978983] wlan0: authenticated
[ 2945.978989] wlan0: associate with AP 00:03:52:1c:18:71
[ 2945.983260] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[ 2945.987126] wlan0: authenticated
[ 2945.987133] wlan0: associate with AP 00:03:52:4d:bd:c1
[ 2945.989185] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x21 sta=
tus=3D0 aid=3D5)
[ 2945.989193] wlan0: associated
[ 2945.993099] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 2945.996542] wlan0: disassociating by local choice (reason=3D3)
[ 2946.012100] wlan0: authenticate with AP 00:03:52:1c:18:71
[ 2946.124737] wlan0: authenticate with AP 00:03:52:4d:e8:81
[ 2946.126610] wlan0: authenticated
[ 2946.126617] wlan0: associate with AP 00:03:52:4d:e8:81
[ 2946.324069] wlan0: associate with AP 00:03:52:4d:e8:81
[ 2946.329690] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[ 2946.329698] wlan0: associated
[ 2946.337616] wlan0: disassociating by local choice (reason=3D3)
[ 2946.457055] wlan0: direct probe to AP 00:03:52:29:41:12 try 1
[ 2946.656623] wlan0: direct probe to AP 00:03:52:29:41:12 try 2
[ 2946.661436] wlan0 direct probe responded
[ 2946.661444] wlan0: authenticate with AP 00:03:52:29:41:12
[ 2946.860096] wlan0: authenticate with AP 00:03:52:29:41:12
[ 2947.060102] wlan0: authenticate with AP 00:03:52:29:41:12
[ 2947.064463] wlan0: authenticated
[ 2947.064470] wlan0: associate with AP 00:03:52:29:41:12
[ 2947.082421] wlan0: RX AssocResp from 00:03:52:29:41:12 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[ 2947.082429] wlan0: associated
[ 2947.087086] wlan0: disassociating by local choice (reason=3D3)
[ 2947.189435] wlan0: authenticate with AP 00:03:52:4d:e7:91
[ 2947.192363] wlan0: authenticated
[ 2947.192371] wlan0: associate with AP 00:03:52:4d:e7:91
[ 2947.197793] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D4)
[ 2947.197800] wlan0: associated
[ 2947.206966] wlan0: disassociating by local choice (reason=3D3)
[ 2947.315272] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[ 2947.318183] wlan0: authenticated
[ 2947.318191] wlan0: associate with AP 00:03:52:4e:f3:d1
[ 2947.320186] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D7)
[ 2947.320194] wlan0: associated
[ 2947.330987] wlan0: disassociating by local choice (reason=3D3)
[ 2947.439431] wlan0: authenticate with AP 00:03:52:4d:d3:21
[ 2947.441455] wlan0: authenticated
[ 2947.441462] wlan0: associate with AP 00:03:52:4d:d3:21
[ 2947.444340] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D6)
[ 2947.444347] wlan0: associated
[ 2947.459246] wlan0: disassociating by local choice (reason=3D3)
[ 2947.563662] wlan0: authenticate with AP 00:03:52:1c:18:71
[ 2947.565537] wlan0: authenticated
[ 2947.565544] wlan0: associate with AP 00:03:52:1c:18:71
[ 2947.567530] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[ 2947.567537] wlan0: associated
[ 2947.574397] wlan0: disassociating by local choice (reason=3D3)
[ 2947.692460] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[ 2947.896072] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[ 2948.092096] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 3
[ 2948.292031] wlan0: direct probe to AP 00:03:52:1b:f8:31 timed out
[ 2952.698119] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[ 2952.896098] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[ 2953.096065] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[ 2953.296105] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[ 2956.477031] wlan0: no IPv6 routers present


--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkodKyUACgkQuL75KpiFGIzUWwCfYm5pKegcMf9Zlr7ZuVuhgGAl
n7UAoOEecHqw/lh71+5uM/cF4YG7YddA
=YRs3
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
