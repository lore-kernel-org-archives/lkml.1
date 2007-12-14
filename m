Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXLNMyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXLNMyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762593AbXLNMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:54:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54745 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXLNMy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:54:27 -0500
Date: Fri, 14 Dec 2007 13:53:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214125327.GA10995@elte.hu>
References: <20071213003028.676998182@mvista.com> <200712141239.51809.mb@bu3sch.de> <20071214121617.GE23964@elte.hu> <200712141331.59410.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712141331.59410.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> This user did get the following messages in dmesg:
> 
> b43err(dev->wl, "Firmware file \"%s\" not found "
>        "or load failed.\n", path);
> b43err(wl, "You must go to "
>        "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>        "and download the correct firmware (version 4).\n");
> 
> I'm not sure how I can improve that even more. There is a full URL 
> describing how to get the device workin in _full_ detail.

well i dont have this hardware, but the following description in this 
thread seems to contradict that:

|| Well, doing an `rmmod bcm43xx ; modprobe ssb b43` gives me nothing in 
|| dmesg other than lines related to the bcm43xx driver. 
|| iwconfig/ifconfig do not see the interface either.

	Ingo
