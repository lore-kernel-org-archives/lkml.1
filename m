Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYJ0R0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYJ0R0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYJ0R03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:26:29 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7116 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYJ0R02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:26:28 -0400
Message-ID: <4905F9BD.100@hp.com>
Date: Mon, 27 Oct 2008 10:26:21 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl, mingo@elte.hu,
       s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
References: <1224905848.5161.27.camel@marge.simson.net>	<20081024.221653.23695396.davem@davemloft.net>	<1224914333.3822.18.camel@marge.simson.net>	<20081025.001940.251852864.davem@davemloft.net> <1224919985.5373.10.camel@marge.simson.net>
In-Reply-To: <1224919985.5373.10.camel@marge.simson.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> That's exactly what I've been trying to look into, but combined with
> netperf.  The thing is an incredibly twisted maze of _this_ affects
> _that_... sometimes involving magic and/or mythical creatures.

I cannot guarantee it will help, but the global -T option to pin netperf 
or netserver to a specific CPU might help cut-down the variables.

FWIW netperf top of trunk omni tests can now also determine and report 
the state of SELinux.  They also have code to accept or generate their 
own RFC4122-esque UUID.  Define some connical tests and then ever closer 
to just needing some database-fu and automagic testing I suppose... 
things I do not presently posess but am curious enough to follow some 
pointers.

happy benchmarking,

rick jones
