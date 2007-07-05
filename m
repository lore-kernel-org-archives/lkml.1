Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbXGEU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbXGEU1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXGEU1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:27:30 -0400
Received: from main.gmane.org ([80.91.229.2]:59991 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXGEU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:27:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: blink driver power saving
Date: Thu, 05 Jul 2007 16:30:46 -0400
Message-ID: <468D54F6.9080808@tmr.com>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz> <20070703071237.GA17476@suse.de> <20070704193711.GG2728@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Andi Kleen <ak@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-70-109-121-113.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070704193711.GG2728@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>>> ...drivers are not expected to act on their own. I was expecting to
>>> get nice /sys/class/led* interface to my keyboard leds.
>> What's the benefit of such an interface? If you're able to trigger
>> keyboard LEDs via that interface, you're also able to use the ioctl()
>> on /dev/console.
> 
> Well, at least it is standartized interface... plus it can do stuff
> like "blink that led on disk access".
> 
One of many useful things for system without blinking lights, disk 
network, thermal alert, etc. And a cheap helper for handicapped folks 
who can't hear an audible alert.

>> I think the intention of the blink driver was to have a *early* blink,
>> i.e. before initrd (and on systems without intrd, before the first
>> init script runs).
> 
> ...and yes, it can autoblink, too. It should be even possible to set
> default behaviour of led to blink, doing what the blink driver does,
> but in a clean way.

Endlessly useful, alarm clock, non-fatal errors on boot, etc.

<it would be nice>
If this were done, priority levels would be nice, so the "I'm taking a 
dump" or "panic" would block lower level system use like disk or network 
lights, and user applications would have some policy to put them higher 
or lower than the pseudo disk light (or not).
</not nice>

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

