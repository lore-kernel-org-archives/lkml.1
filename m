Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKDKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKDKJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYKDKJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:09:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYKDKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:09:08 -0500
Message-ID: <49101E96.2010609@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 18:06:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: add sanity check in partition_sched_domains()
References: <491005C7.2080608@cn.fujitsu.com> <20081104092848.GM23790@elte.hu>
In-Reply-To: <20081104092848.GM23790@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a small detail, i changed this:
> 
>> +		BUG_ON(dattr_new);
> 
> to WARN_ON_ONCE().
> 
> If there's a rare setup-time memory leak we dont want to crash the box 
> via a BUG_ON(), as that only results in unhappy users. We want a 
> WARN_ON_ONCE() so that we get nice bugreports and kerneloops.org 
> coverage as well instead.
> 
> We use BUG_ON() in new code only in the rarest of circumstances: if we 
> absolutely want to bring down the box right there - because there's a 
> serious risk of data corruption, security breach, etc.
> 

I see the point, thx for the explanation. :)

