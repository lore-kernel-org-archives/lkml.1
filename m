Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYEPL5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYEPL5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYEPL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:56:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:42234 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYEPL44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:56:56 -0400
Message-ID: <482D7685.6070300@trash.net>
Date: Fri, 16 May 2008 13:56:53 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Kingsley Foreman <kingsley@internode.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local> <482C81CC.7000305@trash.net> <20080515184646.GC2936@ami.dom.local> <1A70765F4B30462EB21A3B3A8A442633@uglypunk> <20080516054959.GA3918@ff.dom.local> <05be01c8b71b$cbb0c9e0$f903a33a@SABINE> <20080516070102.GB3992@ff.dom.local> <20080516072254.GC3992@ff.dom.local>
In-Reply-To: <20080516072254.GC3992@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Fri, May 16, 2008 at 07:01:02AM +0000, Jarek Poplawski wrote:
>> On Fri, May 16, 2008 at 03:42:18PM +0930, Kingsley Foreman wrote:
>> ...
>>> ok after some playing a bit if i use
>>>
>>> tc qdisc change dev bond0 parent 1: pfifo limit 30
>>>
>>> the dropped packets go away, im not sure if that is considered normal or  
>>> not, however any number under 30 gives me issues.
>> If there are no significant differences in configs between these 2.6.22
>> and 2.6.24/25 (e.g. things mentionned earlier by Eric) IMHO it's "more
>> than normal", but as I've written it would need a lot of your time and
>> work to check the rason.
> 
> BTW, it still doesn't have to mean any error: e.g. it could happen when
> kernel throughput is better while NIC tx speed stayed the same. So, it
> shouldn't probably bother you too much until there is no visible impact
> on latency or rates.


Yes. I don't think this is an error, the configuration
was simply broken.
