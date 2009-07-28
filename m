Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZG1VBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZG1VBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZG1VBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:01:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40114 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZG1VBO (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:01:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Zhu Yi <yi.zhu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: 31-rc3-mmotm0716 - wonky wireless statistics..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248814870_4259P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Jul 2009 17:01:10 -0400
Message-ID: <5934.1248814870@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248814870_4259P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <5914.1248814854.1@turing-police.cc.vt.edu>

Dell Latitude D820 laptop, lspci reports the network card as:

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Netwo           rk Connection (rev 02)

iwlwifi driver in use, card associated via wpa_supplicant but not being
actively used

# iwconfig
wlan0     IEEE 802.11abg  ESSID:"VT-Wireless"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: 00:11:20:A4:4C:10   
          Bit Rate=54 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:<lopped out> [2]
          Link Quality=62/70  Signal level=-48 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
# cat /proc/net/wireless
Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
 wlan0: 0000   63.  -47.  -256        0      0      0      0      0        0
 wlan1: 0000    0     0     0        0      0      0      0      0        0
 wlan2: 0000    0     0     0        0      0      0      0      0        0

Where did that -256 for "noise" come from?  It ends up confusing the
gkrellm-wifi plugin, it reports a S/N of 219dB ;)



--==_Exmh_1248814870_4259P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKb2cWcC3lWbTT17ARAvBpAJ9go5v/W46n8FSib4lHLX/SlRk+MACeIzQj
mesuP854E7Uj2aq+8IBWTOU=
=O9/5
-----END PGP SIGNATURE-----

--==_Exmh_1248814870_4259P--
