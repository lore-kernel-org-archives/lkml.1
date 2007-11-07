Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbXKGXXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbXKGXXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXKGXXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:23:45 -0500
Received: from rtr.ca ([76.10.145.34]:1531 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbXKGXXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:23:44 -0500
Message-ID: <473248FE.2020907@rtr.ca>
Date: Wed, 07 Nov 2007 18:23:42 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards (updated)
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca> <47323B6B.9000909@rtr.ca> <20071107224808.GC15367@electric-eye.fr.zoreil.com>
In-Reply-To: <20071107224808.GC15367@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Mark Lord <lkml@rtr.ca> :
>> Mark Lord wrote:
>>> Francois Romieu wrote:
>>> ..
>>>> I am not convinced, the broken ones include some RTL_GIGA_MAC_VER_12
>>>> too, namely XID = 0x38000000.
>> ..
>>
>> Here is the updated patch for both VER_11 and VER_12.
>> Let's get this in, as the driver has been broken for weeks now.
> 
> I have not been waiting for you and I am not interested in your
> controversy.
> 
> I'll find the offending commit and revert it. It is that simple.
..

I think the rest of the commit was fine -- there seems to be some
nice cleanups there to make it easier to maintain.

Just the new register writes (rtl8168b_hw_phy_config()) are mucking things up.
Prevent those from happening, and all is well.

Cheers

