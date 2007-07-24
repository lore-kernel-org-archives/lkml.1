Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbXGXVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbXGXVVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXGXVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:21:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:45005 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXGXVVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:21:36 -0400
Date: Tue, 24 Jul 2007 14:19:57 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <20070724204327.GA103@tv-sign.ru>
Message-ID: <Pine.LNX.4.63.0707241418400.31240@localhost.localdomain>
References: <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
 <20070718161156.GA761@tv-sign.ru> <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
 <20070720141529.GA218@tv-sign.ru> <Pine.LNX.4.63.0707231858420.9759@localhost.localdomain>
 <20070724145142.GA199@tv-sign.ru> <Pine.LNX.4.63.0707240827320.25961@localhost.localdomain>
 <20070724204327.GA103@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 24 Jul 2007 21:19:58.0837 (UTC) FILETIME=[63A18A50:01C7CE38]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Oleg Nesterov wrote:

> On 07/24, Jeremy Katz wrote:
>>
>> Sorry.  That should have been "without apparent effect".
>
> Sorry. I confused completely.
>
> So. You mean that even with that patch you _still_ see the 
> BUG_ON(!SIGQUEUE_PREALLOC) in sigqueue_free() ?

Yes.  I did not notice any difference in the system's behavior after 
applying the patch.

Jeremy
