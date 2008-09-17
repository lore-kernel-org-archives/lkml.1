Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYIQW3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYIQW3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYIQW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:29:34 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:57206 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYIQW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:29:34 -0400
Message-ID: <48D184CC.2040204@yahoo.com>
Date: Wed, 17 Sep 2008 23:29:32 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no>	<fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no>	<48D17B47.7080704@yahoo.com> <20080917145400.29d1809c@infradead.org>
In-Reply-To: <20080917145400.29d1809c@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 06898238ff689d37dae1556e44f11224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 17 Sep 2008 22:48:55 +0100
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
>> Arjan van de Ven wrote:
>>> this says you haven't done "make install" on the latencytop
>>> directory so it's not translating things for you.. can you do that
>>> please?
>>> Cause                                                Maximum
>>>
> Percentage 
> 
> Scheduler: waiting for cpu                        208 msec         59.4 %
> 
> 
> you're rather CPU bound, and your process was woken up but didn't run for over 200 milliseconds..
> that sounds like a scheduler fairness issue!

I'm at a bit of a loss to explain this. I'm not using the group 
scheduler and the load average is less than 0.4. CPU usage does seem to 
spike a fair bit (I'm not sure why rhythmbox needs 50%+ for decoding 
oggs from time to time) but there always seems to be 20% CPU free...

I don't know where to start debugging this one and I'm suspicious of the 
way the problem would happen every 30 seconds too... (this laptop is 
using ath5k for its wifi)
