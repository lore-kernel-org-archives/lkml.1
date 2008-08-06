Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYHFF7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYHFF7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYHFF7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:59:44 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41151 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHFF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:59:43 -0400
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ivo van Doorn <IvDoorn@gmail.com>
Message-Id: <A0AAD67C-1F54-4D85-A413-91BBBE044452@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [GIT]: Networking
Date: Wed, 6 Aug 2008 07:59:37 +0200
References: <20080805.190020.244441681.davem@davemloft.net> <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org>
X-Mailer: Apple Mail (2.928.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

>> There was going to be the addition of the ath9k wireless driver but
>> there was some fallout that is being worked on right now (linux/ 
>> list.h
>> changes needed lkml review, ath9k driver triggered some gcc aborts,
>> all kinds of fun stuff :-) so hopefully it will make it in the next
>> pass.  I tried to wait an extra day for it to be resolved, but that
>> was optimistic.
>
> Talking about wireless driver updates - has anybody looked at the  
> RaLink
> wireless driver?  It's in the newer EeePC's (901 and 1000), and it
> actually has a driver from the company which the comments make clear  
> is
> GPLv2 too, no apparent oddness or anything:
>
> 	http://www.ralinktech.com.tw/data/drivers/2008_0708_RT2860_Linux_STA_v1.7.0.0.tar.bz2
>
> which admittedly apparently has some trivial problems (with a trivial
> patch as seen at
>
> 	http://fedoraforum.org/forum/showthread.php?t=195429
>
> I'd love to have that one working, since I have the hardware, and it's
> actually reasonable (much more so than the original EeePC, in fact).  
> What
> channels should I go through? Is anybody working on integrating it
> already?

I looked at the driver and got it working. However my 901 seems to  
have an issue with the antennas. I can do scans, but associating with  
an access point or even thinking about transmit keeps failing. Even  
with external antennas this still doesn't work. So either my EeePC is  
broken or it needs some ACPI magic to enable it. Personally I think  
mine is broken since the PCIe hotplug stuff works for the wireless  
card and that seems to be their way of doing the rfkill.

The driver itself is painful. It is full of ifdefs and some crazy  
build magic. The integrated (to some degree optional) WPA code is  
pretty ugly. It has also a full set of iwpriv commands to do all the  
settings etc. :(

Regards

Marcel

