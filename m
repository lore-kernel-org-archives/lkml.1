Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXGZKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXGZKph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXGZKp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:45:27 -0400
Received: from ua-85-227-1-9.cust.bredbandsbolaget.se ([85.227.1.9]:57261 "EHLO
	omoikane.mc.pp.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbXGZKp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:45:26 -0400
X-Greylist: delayed 2091 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 06:45:26 EDT
To: "Peter Bortas" <bortas@gmail.com>
Cc: "Adrian McMenamin" <adrianmcmenamin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lethal@users.sourceforge.net
Subject: Re: [PATCH] Fix DMA on Dreamcast
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
	<20070720120408.1f190269.akpm@linux-foundation.org>
	<92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com>
	<7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com>
	<92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com>
	<7e5f60720707210713o4ff0825eu463abee77dc1f04c@mail.gmail.com>
From: Marcus Comstedt <marcus@mc.pp.se>
Date: Thu, 26 Jul 2007 12:10:30 +0200
In-Reply-To: <7e5f60720707210713o4ff0825eu463abee77dc1f04c@mail.gmail.com> (Peter Bortas's message of "Sat, 21 Jul 2007 16:13:19 +0200")
Message-ID: <yf9y7h3a31l.fsf@mc.pp.se>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


"Peter Bortas" <bortas@gmail.com> writes:

> On 7/21/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
>> On 21/07/07, Peter Bortas <bortas@gmail.com> wrote:
>>
>> >
>> > Sidenote: Does Linux handle the Dreamcast DMA errata?
>> >
>>
>> You need to explain what you mean (at least to me!).
>>
>> If you mean will it degrade gracefully - not without this patch if set
>> to the (correct) defconfig. With iffy settings it will.
>
> If I remember correctly (and that's a big if since I last looked at it
> in 2001) some revisions of the Dreamcast hardware would sporadically
> lock up if you scheduled a new DMA request to quickly after a previous
> one, even if you checked the ready bit. It's worked around by a delay
> of X microseconds as recommended by Sega engineers. I don't remember
> the value of X, nor where exactly in the flow this workaround should
> be applied.
>
> Adding Marcus in case he has a better memory than me.


I don't remeber any such delay.  Are you sure you're not thinking
about the G2 bus problem (where accesses need to be programatically
serialized, whether they are PIO or DMA)?


  // Marcus


