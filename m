Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXEWLg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXEWLg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbXEWLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:36:50 -0400
Received: from stinky.trash.net ([213.144.137.162]:39738 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbXEWLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:36:49 -0400
Message-ID: <4654269C.4040809@trash.net>
Date: Wed, 23 May 2007 13:33:48 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Anant Nitya <kernel@prachanda.info>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bad networking related lag in v2.6.22-rc2
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <20070522062233.GA20002@elte.hu> <200705231110.44526.kernel@prachanda.hub> <20070523063052.GB26814@elte.hu> <46541DC4.4090501@trash.net> <20070523112559.GA24604@gondor.apana.org.au>
In-Reply-To: <20070523112559.GA24604@gondor.apana.org.au>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Wed, May 23, 2007 at 12:56:04PM +0200, Patrick McHardy wrote:
> 
>>Looking at the recent changes to __qdisc_run, this indeed seems
>>to be the case, when the qdisc is throttled and has packets queued
>>we return a value != 0, causing __qdisc_run to loop until all
>>packets have been sent, which may be a long time.
> 
> 
> Good catch! I was obviously half awake at the time :)
> 
> We could also fix it this way:


Yes, that looks better, thanks.
