Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbYCZCwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbYCZCwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYCZCw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:52:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:37573 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYCZCw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:52:28 -0400
Message-ID: <47E9BA6C.2010502@windriver.com>
Date: Wed, 26 Mar 2008 10:52:28 +0800
From: yshi <yang.shi@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B115.9060109@windriver.com>	<47E9B39C.5010502@pobox.com> <20080325.194221.16658596.davem@davemloft.net>
In-Reply-To: <20080325.194221.16658596.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Mar 2008 02:52:23.0829 (UTC) FILETIME=[6AFA8C50:01C88EEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller 写道:
> From: Jeff Garzik <jgarzik@pobox.com>
> Date: Tue, 25 Mar 2008 22:23:24 -0400
>
>   
>> This is bogus -- you should never need to slow down the hot path in such 
>> a way.
>>     
>
> Slow down in what way?  Even on x86 saving the flags is just
> about as expensive as a plain sti/cli.
>
> I would in fact prefer to see drivers unconditionally use
> spin_lock_irqsave() et al. in the interrupt handler, for
> consistency.
>   
Yes, I agree. Many NIC drivers do the same thing, like Gianfar, E1000, etc.

