Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYJ3RY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYJ3RY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYJ3RYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:24:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:48236 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755413AbYJ3RYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:24:44 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18n3ecEAWsnuQ7TpA1JN8bU3VNLyF5LZiSUK3cc9H
	WefUzw+jxDJ15S
Date: Thu, 30 Oct 2008 18:24:33 +0100
From: Mirco Tischler <mt-ml@gmx.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081030182433.0a4eb471@mtlp.12.dimension>
In-Reply-To: <1225261084.2917.254.camel@debian.sh.intel.com>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081027213217.53558319@infradead.org>
	<1225171414.2917.229.camel@debian.sh.intel.com>
	<20081028172418.3c8e91f1@mtlp.12.dimension>
	<1225261084.2917.254.camel@debian.sh.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FNi2SVqLL+xXLz2t0hTvAG0";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FNi2SVqLL+xXLz2t0hTvAG0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2008 14:18:04 +0800, Zhu Yi wrote:
> Can you try attached patch?
>=20
> Thanks,
> -yi
I did. Didn't solve the problems but here's the output:
[  880.195147] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,1.3=
.27kds=20
[  880.195150] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[  880.195300] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
[  880.195327] iwlagn 0000:06:00.0: setting latency timer to 64
[  880.195444] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=3D0x4
[  880.245264] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[  880.247969] phy3: Selected rate control algorithm 'iwl-agn-rs'
[  884.274477] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
[  884.275247] iwlagn 0000:06:00.0: irq 41 for MSI/MSI-X
[  884.275361] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-4965-2.uco=
de
[  884.489886] Registered led device: iwl-phy3:radio
[  884.489933] Registered led device: iwl-phy3:assoc
[  884.489973] Registered led device: iwl-phy3:RX
[  884.490012] Registered led device: iwl-phy3:TX
[  884.526082] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  884.784601] iwlagn: TX Power requested while scanning!
[  884.784611] Pid: 9839, comm: iwlagn/1 Not tainted 2.6.28-rc2-oldreg-debu=
g #27
[  884.784617] Call Trace:
[  884.784632]  [<ffffffff8101a374>] ? native_smp_send_reschedule+0x4d/0x4f
[  884.784658]  [<ffffffffa01c1082>] iwl4965_send_tx_power+0x5a/0xf2f [iwla=
gn]
[  884.784668]  [<ffffffff813c065c>] ? _spin_unlock_irqrestore+0x31/0x3c
[  884.784677]  [<ffffffff8103341f>] ? try_to_wake_up+0x222/0x234
[  884.784685]  [<ffffffff8103343e>] ? default_wake_function+0xd/0xf
[  884.784693]  [<ffffffff8104ace2>] ? autoremove_wake_function+0x11/0x38
[  884.784703]  [<ffffffff8102aee1>] ? __wake_up_common+0x46/0x76
[  884.784710]  [<ffffffff813c065c>] ? _spin_unlock_irqrestore+0x31/0x3c
[  884.784717]  [<ffffffff8102c04f>] ? __wake_up+0x43/0x4f
[  884.784725]  [<ffffffff81047dff>] ? queue_work+0x59/0x68
[  884.784735]  [<ffffffff81395eab>] ?ieee80211_mlme_notify_scan_completed+=
0xc7/0xd9=20
[  884.784743]  [<ffffffff81393708>] ? ieee80211_scan_completed+0x2e8/0x32c
[  884.784770]  [<ffffffffa00d5425>] ? iwl_rx_queue_restock+0xc6/0x143 [iwl=
core]
[  884.784790]  [<ffffffffa00cf290>] iwl_set_tx_power+0x6b/0x71 [iwlcore]
[  884.784812]  [<ffffffffa00de3f6>] iwl_bg_scan_completed+0xbc/0xcd [iwlco=
re]
[  884.784834]  [<ffffffffa00de33a>] ? iwl_bg_scan_completed+0x0/0xcd [iwlc=
ore]
[  884.784842]  [<ffffffff81047298>] run_workqueue+0x95/0x138
[  884.784849]  [<ffffffff81047430>] worker_thread+0xf5/0x109=20
[  884.784856]  [<ffffffff8104acd1>] ? autoremove_wake_function+0x0/0x38
[  884.784864]  [<ffffffff8104733b>] ? worker_thread+0x0/0x109
[  884.784871]  [<ffffffff8104a956>] kthread+0x49/0x76=20
[  884.784879]  [<ffffffff8100d129>] child_rip+0xa/0x11=20
[  884.784886]  [<ffffffff8104a90d>] ? kthread+0x0/0x76=20
[  884.784892]  [<ffffffff8100d11f>] ? child_rip+0x0/0x11

--Sig_/FNi2SVqLL+xXLz2t0hTvAG0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkJ7dgACgkQz+diZ7c2xfjNaQCfb6wFB9Fqf+edf0RAJduuuPP4
8Z0AnRp8TH3oKdZlIJSiSpme/gN+noI8
=EDpY
-----END PGP SIGNATURE-----

--Sig_/FNi2SVqLL+xXLz2t0hTvAG0--
