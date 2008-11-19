Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYKSAIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYKSAIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYKSAIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:08:06 -0500
Received: from 173-8-135-49-SFBA.hfc.comcastbusiness.net ([173.8.135.49]:47488
	"EHLO sandall.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYKSAIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:08:06 -0500
Message-ID: <20081118160802.1451918y5om1qy8z@mail.sandall.us>
Date: Tue, 18 Nov 2008 16:08:03 -0800
From: "Eric Sandall" <eric@sandall.us>
To: "Grant Coady" <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       "Jean Schurger" <jean@schurger.org>
Subject: Re: Linux 2.6.27.6
References: <20081113185350.GA3765@kroah.com>
	<20081118092051.53d1fcc2@sandall.us>
	<8dl6i41eobduef8djn8bj7d1sih07tga47@4ax.com>
In-Reply-To: <8dl6i41eobduef8djn8bj7d1sih07tga47@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Grant Coady" <gcoady.lk@gmail.com>:

> On Tue, 18 Nov 2008 09:20:51 -0800, you wrote:
>
>> On Thu, 13 Nov 2008 10:53:50 -0800
>> Greg KH <gregkh@suse.de> wrote:
>>> We (the -stable team) are announcing the release of the 2.6.27.6
>>> kernel.
>>>
>>> It contains a wide range of bugfixes, and all users of the 2.6.27
>>> kernel series are strongly encouraged to upgrade.
>>>
>>> I'll also be replying to this message with a copy of the patch between
>>> 2.6.27.5 and 2.6.27.6
>>> Francois Romieu (3):
>>>       r8169: get ethtool settings through the generic mii helper
>>>       r8169: fix RxMissed register access
>>>       r8169: wake up the PHY of the 8168
>>
>> My r8169 no longer compiles:
>> ...
>>  Building modules, stage 2.
>>  MODPOST 243 modules
>> ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>> Attached my .config. Also tried witht he following changed, with the
>> same results:
>> +CONFIG_NET_ETHERNET=y
>> +CONFIG_MII=m
>
> r8169 works fine here, from dmesg:
>
> r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> r8169 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> r8169 0000:04:00.0: setting latency timer to 64
> eth0: RTL8168b/8111b at 0xffffc200100b8000, 00:1d:7d:03:5e:98, XID  
> 38000000 IRQ 378
> ...
> r8169: eth0: link up
>
> See: http://bugsplatter.id.au/kernel/boxen/pooh64/ for dmesg + config
>
> Grant.

Mine works fine as well, on 2.6.27.5. It does not even *compile* on  
2.6.27.6. Jean Schurger just sent an e-mail  
(http://marc.info/?l=linux-kernel&m=122703112423031) with the same  
issue, but was kind enough to provide a patch (which I have not tested).

-sandalle

-- 
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us PGP: 0xA8EFDD61  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  http://counter.li.org/  #196285

