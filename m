Return-Path: <linux-kernel-owner+w=401wt.eu-S935399AbXLNAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399AbXLNAqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXLNAp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:45:59 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:42688 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXLNAp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:45:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 01:43:15 +0100
User-Agent: KMail/1.9.6
Cc: bcm43xx-dev@lists.berlios.de, "Daniel Walker" <dwalker@mvista.com>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       "John Linville" <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712131445.39770.mb@bu3sch.de> <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
In-Reply-To: <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140143.16451.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 01:05:00 Ray Lee wrote:
> Okay, I had to modprobe rfkill-input and rfkill by hand, didn't
> realize that. Hopefully that'll be automatic soon. Regardless, upon
> doing so, and loading ssb and b43, it sees my card, but is still not
> fully functional. iwconfig sees:
> 
> lo        no wireless extensions.
> eth0      no wireless extensions.
> tun0      no wireless extensions.
> eth1      no wireless extensions.
> wlan0_rename  IEEE 802.11g  ESSID:""
>           Mode:Managed  Channel:0  Access Point: Not-Associated
>           Tx-Power=0 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2346 B
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> (eth0 is ethernet, eth1 doesn't exist -- usually it's the wireless.)
> 
> `ifconfig` doesn't see eth1 or wlan0_rename.
> 
> What else might I be doing wrong?

I don't know. Try ifconfig -a
Or tell udev to not crap up your device names.

> Regardless, perhaps scheduling 
> bcm43xx for removal in 2.6.26 is a bit premature.

Oh come on. b43 is more than a year old now. How long should we wait?
Two or three? Forever?

-- 
Greetings Michael.
