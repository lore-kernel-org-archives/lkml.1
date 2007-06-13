Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXFMLqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXFMLqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXFMLq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:46:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50376 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757699AbXFMLq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:46:26 -0400
Date: Wed, 13 Jun 2007 13:46:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613114613.GA1998@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com> <20070613114326.GA1973@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613114326.GA1973@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks for help. I was finaly able to make it to work. It is quite
> sensitive to order of commands... and still does not light the led up
> on x60, but it works. (Part of problem was that it tried to associate
> in 5GHz range, and another part was my error in configuring IP
> addresses).

root@amd:~# tcpspray -n 10 -b 10000000  10.0.0.2

Transmitted 100000000 bytes in 131.993797 seconds (739.855 kbytes/s)

Hmm, is this normal? 1MB/sec is 8Mbit.

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

irlan0    no wireless extensions.

wmaster0  no wireless extensions.

Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     IEEE 802.11g  ESSID:"pavel"
          Mode:Managed  Frequency:2.412 GHz  Access Point:
00:11:2F:0E:95:A0
          Bit Rate=11 Mb/s
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:off
          Link Quality=81/100  Signal level=-31 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#

Aha, bit rate=11 Mb/sec. .. Ok, I do not need 50Mb/sec, but it would
be nice. ASUS AP claims 80211g 54Mbps in big bold letters :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
