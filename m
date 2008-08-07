Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYHGIHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYHGIHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 04:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHGIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:06:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41137 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYHGIG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:06:56 -0400
Message-ID: <489AAD1B.10901@garzik.org>
Date: Thu, 07 Aug 2008 04:06:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHes] pull request: WAN
References: <m3ljzyc9e7.fsf@maximus.localdomain> <488653A9.50001@garzik.org> <m3hcags2xq.fsf@maximus.localdomain>
In-Reply-To: <m3hcags2xq.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Anything in upstream-next went upstream, and so we need to apply this
>> on top of the current Linus upstream (torvalds/linux-2.6.git) at the
>> very least.
>>
>> Would you mind doing that, please?
> 
> No problem, though I guess David would hate us both if I do that,
> so I actually rebased on top of your "upstream" instead, is it ok?
> 
> It's now at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git for-jeff
> 
>> Also, git pulls are great, but it would be helpful if you supply a
>> git-shortlog summary of the changes, and the patch (>400k will only go
>> to me, list will ignore).
> 
> Sure,
> 
> Krzysztof Ha³asa (15):
>       WAN: cosmetic changes to generic HDLC
>       Remove bogus dosyncppp variable from synclink drivers.
>       Remove bogus variables from syncppp.[ch]
>       Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
>       wanmain.c doesn't need syncppp.h
>       WAN: Remove unneeded "#include <net/syncppp.h>"
>       WAN: Remove dead code from PC300 driver, part #1
>       WAN: Remove dead code from PC300 driver, part #2
>       WAN: Convert PC300 driver to use normal u8/u16/u32 types
>       WAN: farsync driver no longer uses syncppp.c directly
>       WAN: Port COSA driver to generic HDLC.
>       WAN: Convert Zilog-based drivers to generic HDLC
>       WAN: Port LMC driver to generic HDLC
>       WAN: don't mention syncppp in z8530 DocBook.
>       WAN: Use u32 type instead of u_int32_t in LMC driver.

pulled


