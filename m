Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZLGIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZLGIbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZLGIbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:31:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758969AbZLGIbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:31:40 -0500
Message-ID: <4B1CBD0D.1000406@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 16:30:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf_event: Eliminate raw->size
References: <4B1C8CC4.4050007@cn.fujitsu.com>	 <tip-f48f669d42e133db839af16656fd720107ef6742@git.kernel.org> <1260173629.8223.1068.camel@laptop>
In-Reply-To: <1260173629.8223.1068.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Mon, 2009-12-07 at 05:31 +0000, tip-bot for Xiao Guangrong wrote:
>> Commit-ID:  f48f669d42e133db839af16656fd720107ef6742
>> Gitweb:     http://git.kernel.org/tip/f48f669d42e133db839af16656fd720107ef6742
>> Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> AuthorDate: Mon, 7 Dec 2009 13:04:04 +0800
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Mon, 7 Dec 2009 06:26:25 +0100
>>
>> perf_event: Eliminate raw->size
>>
>> raw->size is not used, this patch just cleans it up.
> 
> This patch feels wrong.. I would suspect it to be used to validate the
> data parsing, like do we consume past the end and did we consume
> everything.
> 

But as i noticed in current code, it just use raw->data, maybe i miss something?
what i do is just using 'data' instead of 'raw->data' :-(

Thanks,
Xiao

> 
> 
