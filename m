Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756837AbYGWXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYGWXp1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 23 Jul 2008 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYGWXpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:45:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbYGWXo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=ZkoQprrQqU2XpVomWy1HEFPRz0ac1GrZoNznyJhJVX8Z2XWpJXV6RFSJYFgwOun8KJ
         4STNLRPruAGsHScAuuoMMfm2YE2pKQSe39yZhjhHa50jfUrs23XF6sz43ieX61y2WULT
         x1zcC9oDsMR21kHLS0r2UfFXedYEM9hX2Qg2g=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: wireless chip reinitialized (b43)
Date: Thu, 24 Jul 2008 02:44:54 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807240244.55224.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm an exclusive wireless user (at home, at least) and a pretty happy
one too. However, today something didn't go right:

[11278.445832] b43-phy0 ERROR: PHY transmission error
[11278.449861] b43-phy0 ERROR: PHY transmission error
[11278.452122] b43-phy0 ERROR: PHY transmission error
[11285.052841] __ratelimit: 12 messages suppressed
[11285.052841] b43-phy0 ERROR: PHY transmission error
[11290.473424] __ratelimit: 9 messages suppressed
[11290.473424] b43-phy0 ERROR: PHY transmission error
[11294.955712] __ratelimit: 3 messages suppressed
[11294.955726] b43-phy0 ERROR: PHY transmission error
[11298.435943] __ratelimit: 93 messages suppressed
[11298.435952] b43-phy0 ERROR: PHY transmission error
[11303.433619] __ratelimit: 143 messages suppressed
[11303.433619] b43-phy0 ERROR: PHY transmission error
[11308.546863] __ratelimit: 282 messages suppressed
[11308.546863] b43-phy0 ERROR: PHY transmission error
[11313.610472] __ratelimit: 281 messages suppressed
[11313.610472] b43-phy0 ERROR: PHY transmission error
[11318.432246] __ratelimit: 281 messages suppressed
[11318.432246] b43-phy0 ERROR: PHY transmission error
[11323.441897] __ratelimit: 417 messages suppressed
[11323.441897] b43-phy0 ERROR: PHY transmission error
[11328.492385] __ratelimit: 301 messages suppressed
[11328.492385] b43-phy0 ERROR: PHY transmission error
[11329.849144] b43-phy0 debug: Wireless interface stopped
[11329.850941] b43-phy0 debug: DMA-32 rx_ring: Used slots 3/64, Failed frames 0/0 = 0.0%, Average tries 0.00
[11329.851862] b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[11329.853482] b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[11329.855434] b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[11329.857355] b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 110/128, Failed frames 1332/114913 = 1.1%, Average tries 1.47
[11329.859335] b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
[11329.988974] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[11331.213499] b43-phy0 debug: Chip initialized
[11331.213883] b43-phy0 debug: 32-bit DMA initialized
[11331.222884] b43-phy0 debug: Wireless interface started

I'm pretty used with the "transmission error" messages, but the
"interface stopped/started" are new and had the effect of "locking"
me out of the network (so to speak). I had to reinitialize the
interface via:
  # /etc/init.d/net.wlan0 restart

Is this new to everyone?

I'm using a 2.6.26 vanilla kernel:
  # uname -a
  Linux mdontu-dell 2.6.26 #2 SMP PREEMPT Tue Jul 15 00:19:02 EEST
  2008 x86_64 Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel
  GNU/Linux
on a DELL Latitude D520, with a:
  0c:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g
  (rev 01)

Thanks,

PS: This is the first time it happens to me and I don't know how to
reproduce it. I'm sorry.

-- 
Mihai Donțu
