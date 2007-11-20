Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbXKTV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbXKTV4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXKTV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:56:10 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50303 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbXKTV4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:56:10 -0500
Message-ID: <474357EC.4080107@oracle.com>
Date: Tue, 20 Nov 2007 13:55:56 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: drepper@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>	<20071119.235944.82120402.davem@davemloft.net>	<474305A5.7070100@redhat.com> <20071120.134839.229691661.davem@davemloft.net>
In-Reply-To: <20071120.134839.229691661.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Where does this INDIRECT_PARAM() macro get defined?  I do not
>>> see it being defined anywhere in these patches.
>> Defined in <linux/indirect.h>:
>>
>> +#define INDIRECT_PARAM(set, name) current->indirect_params.set.name
>>
>> Not my idea, I was following one review comment.
> 
> This was not in the patches you posted, I double checked before
> sending my reply.

Not to belabor this point, but it was:

http://lkml.org/lkml/2007/11/20/53

$ grep -l INDIRECT_PARAM .git/patches/master/*
.git/patches/master/indirect-v4-4.patch
.git/patches/master/indirect-v4-5.patch
.git/patches/master/indirect-v4-6.patch

Maybe the patches got to you out of order so you saw 5/ before 4/?

- z

