Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYJ1CFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYJ1CFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 22:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJ1CF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 22:05:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:33354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752113AbYJ1CF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:05:26 -0400
X-Authenticated: #29043012
X-Provags-ID: V01U2FsdGVkX1+nQJ4H3nCn3Ew7cTBUaJI9nQ+ASIzV7wUq9iAf5B
	LtBgeP1Kt4S3U+
Date: Tue, 28 Oct 2008 03:05:13 +0100
From: Mirco Tischler <mircotischler@gmx.net>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081028030513.11158870@mtlp.12.dimension>
In-Reply-To: <20081028020212.0dfcb6c9@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7.IAd2PpRHQ6K46J07ogSoJ";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7.IAd2PpRHQ6K46J07ogSoJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2008 02:02:12 +0100, Mirco Tischler wrote:
> Hi
>=20
> I have problems connecting to wlan with my iwl4965 chip and 2.6.28-rc2 (d=
idn't
> test -rc1). Networkmanager just times out every time.
> Only after playing around with rmmod/modprobe and killswitch I am sometim=
es
> able to connect. But I cannot reproduce this reliably yet.
>=20
> This is what I get in dmesg (from modprobe iwlagn to connection failure):
>=20
> [ 1881.884690] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> Linux,1.3.27kds
> [ 1881.884692] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> [ 1881.884809] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> I=
RQ 18
> [ 1881.884836] iwlagn 0000:06:00.0: setting latency timer to 64
> [ 1881.884952] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=3D0x4
> [ 1881.935149] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
> [ 1881.936327] phy4: Selected rate control algorithm 'iwl-agn-rs'
> [ 1885.965591] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> I=
RQ 18
> [ 1885.965874] iwlagn 0000:06:00.0: irq 41 for MSI/MSI-X
> [ 1885.965974] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-4965-2.u=
code
> [ 1886.181600] Registered led device: iwl-phy4:radio
> [ 1886.181618] Registered led device: iwl-phy4:assoc
> [ 1886.181635] Registered led device: iwl-phy4:RX
> [ 1886.181654] Registered led device: iwl-phy4:TX
> [ 1886.213631] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 1887.572768] iwlagn: TX Power requested while scanning!
>=20
> What might be related is this early on boot:
>=20
> [    0.163009] cfg80211: Calling CRDA to update world regulatory domain
> [    0.163012] cfg80211: Failed calling CRDA
> [    0.163024] cfg80211: calling CRDA failed - unable to update world
> regulatory domain, using static definition
>=20
> Need any further info?
>=20
> thanks
>=20
> Mirco
Resubmit because of broken email header.

--Sig_/7.IAd2PpRHQ6K46J07ogSoJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkGc2IACgkQz+diZ7c2xfjASwCaA0oDTz33u9VYqFXlKj0O8snt
jg8An11QPMd5untfG4eXPGcWkJfmRrBp
=Mo8c
-----END PGP SIGNATURE-----

--Sig_/7.IAd2PpRHQ6K46J07ogSoJ--
