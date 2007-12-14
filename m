Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXLNNMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXLNNMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbXLNNL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:11:56 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:52146 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbXLNNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:11:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 14:08:59 +0100
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       John Linville <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712141331.59410.mb@bu3sch.de> <20071214125327.GA10995@elte.hu>
In-Reply-To: <20071214125327.GA10995@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141409.00311.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 13:53:27 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > This user did get the following messages in dmesg:
> > 
> > b43err(dev->wl, "Firmware file \"%s\" not found "
> >        "or load failed.\n", path);
> > b43err(wl, "You must go to "
> >        "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> >        "and download the correct firmware (version 4).\n");
> > 
> > I'm not sure how I can improve that even more. There is a full URL 
> > describing how to get the device workin in _full_ detail.
> 
> well i dont have this hardware, but the following description in this 
> thread seems to contradict that:
> 
> || Well, doing an `rmmod bcm43xx ; modprobe ssb b43` gives me nothing in 
> || dmesg other than lines related to the bcm43xx driver. 
> || iwconfig/ifconfig do not see the interface either.

Let's quote another of Ray's statements:
"And ifconfig -a does indeed show it, sorry about that."

So if he did then try to initialize that device, that clearly
_did_ show up in a standard place where network devices are
expected to show up, he did see the message I quoted.
Well, what if he did not try to initialize the device by doing
an "ifconfig wlanX up"? That can hardly be my fault, right?

-- 
Greetings Michael.
