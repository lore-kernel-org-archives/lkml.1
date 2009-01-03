Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZACAcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZACAcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbZACAcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:32:24 -0500
Received: from lucidpixels.com ([75.144.35.66]:34548 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbZACAcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:32:23 -0500
Date: Fri, 2 Jan 2009 19:32:21 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@infradead.org>
Subject: Re: 2.6.27/2.6.28: irqbalance dies shortly after starting the daemon
 on x86 but not x86_64, why?
In-Reply-To: <495E93D4.3060401@linux.intel.com>
Message-ID: <alpine.DEB.1.10.0901021931140.19502@p34.internal.lan>
References: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan> <495E93D4.3060401@linux.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2 Jan 2009, Arjan van de Ven wrote:

> Justin Piszcz wrote:
>> (same on both x86 and x86_64):
>> # cat /etc/default/irqbalance
>> #Configuration for the irqbalance daemon
>> 
>> #Should irqbalance be enabled?
>> ENABLED=1
>> #Balance the IRQs only once?
>> ONESHOT="0"
>
>
> which version of irqbalance is this?
>

$ dpkg -l | grep -i irqbalance
ii  irqbalance                           0.55-2.4                      Daemon to balance interrupts for SMP systems

Kyle stated:
> If there is only one cache domain, ie: one physical cpu socket with two
> cores sharing a cache, then irqbalance will return after the initial
> balance since it would be pointless to continue running. (It forces
> itself into oneshot mode.)

The CPU = E6700 so yep, so if there is one physical socket with 4 cores it
keeps?  For it to keep and not oneshot you need > 2 cores?

Justin.

