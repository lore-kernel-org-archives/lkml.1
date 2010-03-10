Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0CJDgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:36:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48793 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0CJDgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:36:12 -0500
Date: Wed, 10 Mar 2010 14:36:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
       Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: linux-next: build failure after merge of the wireless tree
Message-Id: <20100310143605.8a20d310.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Mar_2010_14_36_05_+1100_IrxP2zk+BC8fe/Qo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Mar_2010_14_36_05_+1100_IrxP2zk+BC8fe/Qo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/wl12xx/wl1271_sdio.c:31:23: error: plat/gpio.h: No suc=
h file or directory
drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_rea=
d':
drivers/net/wireless/wl12xx/wl1271_sdio.c:121: warning: format '%d' expects=
 type 'int', but argument 3 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_sdio_raw_wri=
te':
drivers/net/wireless/wl12xx/wl1271_sdio.c:144: warning: format '%d' expects=
 type 'int', but argument 3 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_sdio.c: In function 'wl1271_probe':
drivers/net/wireless/wl12xx/wl1271_sdio.c:198: error: implicit declaration =
of function 'gpio_to_irq'

Caused by commit 5129dffebd4eab1749e63bb4a1b7abdc92903227 ("wl1271:
Initial SDIO implementation").  I assume this is only meant to be built
for arm?

I have used the version of the wireless tree from next-20100309 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

P.S. I also got the following warnings:

drivers/net/wireless/mwl8k.c: In function 'mwl8k_rxd_8366_ap_process':
drivers/net/wireless/mwl8k.c:752: warning: 'noise' is deprecated (declared =
at include/net/mac80211.h:557)
drivers/net/wireless/mwl8k.c: In function 'mwl8k_rxd_sta_process':
drivers/net/wireless/mwl8k.c:854: warning: 'noise' is deprecated (declared =
at include/net/mac80211.h:557)
drivers/net/wireless/libertas_tf/main.c: In function 'lbtf_rx':
drivers/net/wireless/libertas_tf/main.c:497: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/rt2x00/rt2x00dev.c: In function 'rt2x00lib_rxdone':
drivers/net/wireless/rt2x00/rt2x00dev.c:437: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_rx_reply_rx':
drivers/net/wireless/iwlwifi/iwl-3945.c:682: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-3945.c:685: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-3945.c:689: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-3945.c:697: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-3945.c:711: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/p54/txrx.c: In function 'p54_rx_data':
drivers/net/wireless/p54/txrx.c:353: warning: 'noise' is deprecated (declar=
ed at include/net/mac80211.h:557)
drivers/net/wireless/ath/ar9170/main.c: In function 'ar9170_rx_phy_status':
drivers/net/wireless/ath/ar9170/main.c:928: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/b43/xmit.c: In function 'b43_rx':
drivers/net/wireless/b43/xmit.c:613: warning: 'noise' is deprecated (declar=
ed at include/net/mac80211.h:557)
drivers/net/wireless/b43legacy/xmit.c: In function 'b43legacy_rx':
drivers/net/wireless/b43legacy/xmit.c:551: warning: 'noise' is deprecated (=
declared at include/net/mac80211.h:557)
drivers/net/wireless/wl12xx/wl1251_rx.c: In function 'wl1251_rx_status':
drivers/net/wireless/wl12xx/wl1251_rx.c:80: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/ath/ath5k/base.c: In function 'ath5k_tasklet_rx':
drivers/net/wireless/ath/ath5k/base.c:1941: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/ath/ath5k/base.c:1942: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/ath/ath9k/common.c: In function 'ath9k_cmn_rx_skb_prep=
rocess':
drivers/net/wireless/ath/ath9k/common.c:215: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/wl12xx/wl1271_rx.c: In function 'wl1271_rx_status':
drivers/net/wireless/wl12xx/wl1271_rx.c:139: warning: 'noise' is deprecated=
 (declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_rx_reply_rx':
drivers/net/wireless/iwlwifi/iwl-rx.c:1145: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-rx.c:1147: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)
drivers/net/wireless/iwlwifi/iwl-rx.c:1160: warning: 'noise' is deprecated =
(declared at include/net/mac80211.h:557)

--Signature=_Wed__10_Mar_2010_14_36_05_+1100_IrxP2zk+BC8fe/Qo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuXE6UACgkQjjKRsyhoI8wxiACfeCSVKpMH53B24sVUzLbKe0U7
3EUAn1+KzFxT6UYOhMxwbz6LZoD1P6b5
=0ZkN
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Mar_2010_14_36_05_+1100_IrxP2zk+BC8fe/Qo--
