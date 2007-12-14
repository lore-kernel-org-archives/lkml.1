Return-Path: <linux-kernel-owner+w=401wt.eu-S1765738AbXLNKwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765738AbXLNKwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbXLNKvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:51:54 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:37967 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765626AbXLNKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:51:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 11:49:46 +0100
User-Agent: KMail/1.9.6
Cc: bcm43xx-dev@lists.berlios.de, "Daniel Walker" <dwalker@mvista.com>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       "John Linville" <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712140143.16451.mb@bu3sch.de> <2c0942db0712131712t6f30ab88g48cc1af27a7a6ce9@mail.gmail.com>
In-Reply-To: <2c0942db0712131712t6f30ab88g48cc1af27a7a6ce9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141149.46945.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 02:12:25 Ray Lee wrote:
> Digging a little farther into it, it looks like b43 is barfing partway
> through init as the firmware file it's looking for has changed names.
> Perhaps that's the issue. I'll take a longer look at this all
> tomorrow.

http://www.linuxwireless.org/en/users/Drivers/b43#firmwareinstallation

> Well, it only hit the main kernel October 10th. That means no final
> point release of the kernel.org kernel has even had it included! So
> testing-wise, you still haven't hit the hordes yet. Scheduling a
> removal of bcm43xx (as painful as that code is [*]), seems either
> premature or very optimistic. So, how about scheduling the removal
> once you get a feel for the bug reports that'll come in once 2.6.24 is
> released.

So you volunteer to maintain bcm43xx? Fine. Thanks a lot.

>    [*] Yeah, even as a user the code is painful. It *still* locks my
> keyboard if I happen to disable the wireless while it's scanning. The
> sooner bcm43xx is dead, the better. But b43 is quite obviously not a
> full replacement for everyone.

I'm pretty sure it is.
Please carefully read the instructions on
http://www.linuxwireless.org/en/users/Drivers/b43
especially for firmware installation.
It will work very well.

-- 
Greetings Michael.
