Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbZJJANj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbZJJANj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZJJANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:13:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45277 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZJJANh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:13:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: mmotm 2009-10-09-01-07 - iwl3945 fails to do firmware load request
In-Reply-To: Your message of "Fri, 09 Oct 2009 01:07:49 PDT."
             <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255133561_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Oct 2009 20:12:41 -0400
Message-ID: <16108.1255133561@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.38.202 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4ACFD17C.00A5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255133561_2897P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <16101.1255133561.1@turing-police.cc.vt.edu>

On Fri, 09 Oct 2009 01:07:49 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-10-09-01-07 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Broke my iwl3945 wireless card:

Good (2.6.31-mmotm0917)
Oct  8 09:55:33 turing-police kernel: [    0.809101] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Oct  8 09:55:33 turing-police kernel: [    0.809106] iwl3945: Copyright(c) 2003-2009 Intel Corporation
Oct  8 09:55:33 turing-police kernel: [    0.809201] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  8 09:55:33 turing-police kernel: [    0.879463] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Oct  8 09:55:33 turing-police kernel: [    0.879466] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 3945ABG
...
Oct  8 09:55:35 turing-police kernel: [   31.599751] iwl3945 0000:0c:00.0: firmware: requesting iwlwifi-3945-2.ucode
Oct  8 09:55:35 turing-police kernel: [   31.697046] iwl3945 0000:0c:00.0: loaded firmware version 15.28.2.8
Oct  8 09:55:35 turing-police kernel: [   31.777214] Registered led device: iwl-phy0::radio
Oct  8 09:55:35 turing-police kernel: [   31.777430] Registered led device: iwl-phy0::assoc
Oct  8 09:55:35 turing-police kernel: [   31.777545] Registered led device: iwl-phy0::RX
Oct  8 09:55:35 turing-police kernel: [   31.777676] Registered led device: iwl-phy0::TX
Oct  8 09:55:35 turing-police kernel: [   31.789446] ADDRCONF(NETDEV_UP): wlan0: link is not ready
(and then wpa-supplicant is able to bring the card up when it finally gets launched by initscripts)

Bad 2.6.32-rc3-mmotm1009:

Oct  9 13:50:19 turing-police kernel: [    0.931788] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Oct  9 13:50:19 turing-police kernel: [    0.944678] iwl3945: Copyright(c) 2003-2009 Intel Corporation
Oct  9 13:50:19 turing-police kernel: [    0.957831] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  9 13:50:19 turing-police kernel: [    1.038946] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Oct  9 13:50:19 turing-police kernel: [    1.038950] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 3945ABG

We never see the firmware load request, and of course everything goes
pear-shaped after that doesn't happen....

Kernel is built with:

%  zgrep -i iwl /proc/config.gz 
CONFIG_IWLWIFI=y
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y


--==_Exmh_1255133561_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKz9F5cC3lWbTT17ARAp0PAKCM8GkD+4UH5mjcp7Z7rfDmqDl26QCfRhX3
C6+JE99sXVKrkIhQAsNXqCQ=
=HEg4
-----END PGP SIGNATURE-----

--==_Exmh_1255133561_2897P--

