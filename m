Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYJJNZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYJJNZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbYJJNZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:25:15 -0400
Received: from netgear.net.ru ([195.178.208.66]:52526 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758903AbYJJNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:25:13 -0400
Date: Fri, 10 Oct 2008 17:25:10 +0400
From: Evgeniy Polyakov <s0mbre@tservice.net.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081010132510.GA25834@tservice.net.ru>
References: <20081009231759.GA8664@tservice.net.ru> <20081010080910.GA31723@tservice.net.ru> <20081010091511.GC5116@elte.hu> <20081010113100.GA1030@tservice.net.ru> <20081010114042.GA19487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010114042.GA19487@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 01:40:42PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> make sure you have this fix in tip/master already:
> 
>   5b7dba4: sched_clock: prevent scd->clock from moving backwards
> 
> Note: Mike is 100% correct in suggesting that a very good cpu_clock() is 
> needed for precise scheduling.

The last commit is 5dc64a3442b98eaa and aforementioned changeset was included.
Result is quite bad:

vanilla 27: 	347.222
no TSO/GSO:	357.331
no hrticks:	382.983
no balance:	389.802
tip:		365.576

-- 
	Evgeniy Polyakov
