Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYH2KgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYH2KgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYH2KgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:36:01 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40584 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYH2KgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:36:00 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 06:36:00 EDT
Message-ID: <48B7CBA7.4060107@grupopie.com>
Date: Fri, 29 Aug 2008 11:12:55 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT]: Networking
References: <20080805.190020.244441681.davem@davemloft.net> <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org> <200808061021.56150.IvDoorn@gmail.com>
In-Reply-To: <200808061021.56150.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo van Doorn wrote:
> On Wednesday 06 August 2008, Linus Torvalds wrote:
>> On Tue, 5 Aug 2008, David Miller wrote:
>>> There was going to be the addition of the ath9k wireless driver but
>>> there was some fallout that is being worked on right now (linux/list.h
>>> changes needed lkml review, ath9k driver triggered some gcc aborts,
>>> all kinds of fun stuff :-) so hopefully it will make it in the next
>>> pass.  I tried to wait an extra day for it to be resolved, but that
>>> was optimistic.
>> Talking about wireless driver updates - has anybody looked at the RaLink 
>> wireless driver?  It's in the newer EeePC's (901 and 1000), and it 
>> actually has a driver from the company which the comments make clear is 
>> GPLv2 too, no apparent oddness or anything:
>>
>> 	http://www.ralinktech.com.tw/data/drivers/2008_0708_RT2860_Linux_STA_v1.7.0.0.tar.bz2
>>
>> which admittedly apparently has some trivial problems (with a trivial 
>> patch as seen at
>>
>> 	http://fedoraforum.org/forum/showthread.php?t=195429
>>
>> I'd love to have that one working, since I have the hardware, and it's 
>> actually reasonable (much more so than the original EeePC, in fact). What 
>> channels should I go through? Is anybody working on integrating it 
>> already?
> 
> Like the earlier rt2x00 drivers I am rewriting the driver as released by Ralink and
> have put it in the rt2x00lib/mac80211 framework. Most of the code is currently done, and the
> last part should be done this week. After that it is a matter of testing and comparing
> register values with the Ralink driver for the last tweaks.

Hi Ivo,

I'm now a EeePc 901 owner. I'd also like to have wireless working on
this machine.
I'm available for any test you might want to undertake so, do not
hesitate to ask.

> 
> I doubt the driver will be ready/stable for 2.6.28, but it should be ready for 2.6.29.
> 
> Ivo
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

-- 
Regards,
Rui Santos

