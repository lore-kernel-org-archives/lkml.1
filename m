Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYJJLzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYJJLzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYJJLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:55:21 -0400
Received: from matrixpower.ru ([195.178.208.66]:46031 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbYJJLzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:55:20 -0400
Date: Fri, 10 Oct 2008 15:55:18 +0400
From: Evgeniy Polyakov <s0mbre@tservice.net.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081010115518.GA3159@tservice.net.ru>
References: <20081009231759.GA8664@tservice.net.ru> <20081010080910.GA31723@tservice.net.ru> <20081010091511.GC5116@elte.hu> <20081010113100.GA1030@tservice.net.ru> <20081010114245.GB19487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010114245.GB19487@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 01:42:45PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > vanilla 27: 347.222
> > no TSO/GSO: 357.331
> > no hrticks: 382.983
> > no balance: 389.802
> 
> okay. The target is 470 MB/sec, right? (Assuming the workload is sane 
> and 'fixing' it does not mean we have to schedule worse.)

Well, that's where I started/stopped, so maybe we will even move
further? :)

-- 
	Evgeniy Polyakov
