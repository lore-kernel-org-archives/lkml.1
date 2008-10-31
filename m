Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYJaNEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYJaNEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYJaNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:04:16 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:41845 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJaNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:04:15 -0400
Date: Fri, 31 Oct 2008 11:05:02 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, willy@linux.intel.com,
       lrodriguez@atheros.com
Subject: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081031110502.18e33eba@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi guys,

 If I do a 'rmmod eeepc-laptop', while connected to my AP, I get the
following error messages from ath5k:

"""
ath5k phy0: noise floor calibration timeout (2417MHz)
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: can't reset hardware (-5)
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: can't reset hardware (-5)
wlan0: No ProbeResp from current AP 00:1d:0f:e9:c7:c0 - assume out of range
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: ath5k_chan_set: unable to reset channel (2412 Mhz)
wlan0: failed to set freq to 2412 MHz for scan
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: ath5k_chan_set: unable to reset channel (2417 Mhz)
wlan0: failed to set freq to 2417 MHz for scan
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: ath5k_chan_set: unable to reset channel (2422 Mhz)
wlan0: failed to set freq to 2422 MHz for scan
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: ath5k_chan_set: unable to reset channel (2427 Mhz)
wlan0: failed to set freq to 2427 MHz for scan
ath5k phy0: failed to wakeup the MAC Chip
ath5k phy0: ath5k_chan_set: unable to reset channel (2432 Mhz)
wlan0: failed to set freq to 2432 MHz for scan
wlan0: failed to set freq to 2437 MHz for scan
wlan0: failed to set freq to 2442 MHz for scan
wlan0: failed to set freq to 2447 MHz for scan
wlan0: failed to set freq to 2452 MHz for scan
wlan0: failed to set freq to 2457 MHz for scan
wlan0: failed to set freq to 2462 MHz for scan
wlan0: failed to set freq to 2467 MHz for scan
wlan0: failed to set freq to 2472 MHz for scan
wlan0: failed to set freq to 2484 MHz for scan
wlan0: failed to restore operational channel after scan
wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
wlan0: authentication with AP 00:1d:0f:e9:c7:c0 timed out
"""

 Then I lost my wireless connection.

 I'm running latest Linus git tree (2.6.28-rc2) on a Eeepc 701.

 The problem doesn't happen on 2.6.27.4, but as 2.6.28-rc1 doesn't
boot on this machine, it would be a bit difficult to bisect it.

 Thanks.

-- 
Luiz Fernando N. Capitulino
