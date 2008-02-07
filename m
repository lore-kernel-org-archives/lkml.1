Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYBGQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYBGQMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYBGQMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:12:40 -0500
Received: from rekin26.go2.pl ([193.17.41.76]:39943 "EHLO rekin26.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbYBGQMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:12:39 -0500
X-Greylist: delayed 25717 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 11:12:39 EST
Subject: =?UTF-8?Q?Re:_Bug=3F_Kernels_2.6.2x_drops_TCP_packets_over_wireless?=
	=?UTF-8?Q?_(independent_of_card_used)?=
From: =?UTF-8?Q?Marcin_Koziej?= <marcinkoziej@o2.pl>
To: =?UTF-8?Q?Oliver_Pinter?= <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40802070623t55115dc3h4cf508e432b9296f@mail.gmail.com>
References: <56de948.2f1b076b.47aac980.bfd66@o2.pl> <6101e8c40802070623t55115dc3h4cf508e432b9296f@mail.gmail.com>
Mime-Version: 1.0
Message-ID: <776aaa6c.68622465.47ab2df0.78e4b@o2.pl>
Date: Thu, 07 Feb 2008 17:12:32 +0100
X-Originator: 193.222.135.194
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> hmm, i think, the site is broken (193.219.28.140), and not the card or
> the driver is wrong. when it does, then other sites are auch
> reproductable ..
> 
> /* is use auch madwifi-0.9.3.3, but it think, it is not driver problem */

Unfortunately, this is not the case :(  This happens to all TCP connections, inside and outside LAN,
also with the telnet session with the router. I also tried to manipulate MTU, but without any positive effect.
I also tried to change things like net.ipv4.tcp_congestion_control -- which i figured out might affect TCP traffic, but also didn't get any results.
I'm afraid this can have something to do with IRQ, because the PCMCIA cards (my Atheros wireless card is such) are visible only with irqpoll kernel option.

Of course, as I mentioned, everything works fine with kernel 2.6.19; with the same servers etc.

Thank You for reply, best regards
Marcin Koziej
