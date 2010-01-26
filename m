Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074Ab0AZD02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0AZD02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794Ab0AZD00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:26:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0AZD00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:26:26 -0500
Message-ID: <4B5E607F.2040204@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 11:24:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] tracing: Change trace_seq to use separate buffer
References: <4B556078.7000004@cn.fujitsu.com> <20100120184046.GA6194@nowhere>
In-Reply-To: <20100120184046.GA6194@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 19, 2010 at 03:34:16PM +0800, Lai Jiangshan wrote:
>> @@ -3124,6 +3126,8 @@ waitagain:
>>  	if (cnt >= PAGE_SIZE)
>>  		cnt = PAGE_SIZE - 1;
>>  
>> +	trace_seq_reset(&iter->seq);
>> +
> 
> 
> 
> So we actually add a trace_seq_reset here.
> This should have been in the first patch, which drops
> the memset, and eventually modified here, just to avoid
> breaking things in the middle of a patchset.
> 
> Things were already broken though before the memset dropping
> patch though in other ways, so it's not that important I guess...
> 
> 

There is no trace_seq_reset() before this patch applied.
trace_seq_init() in the first patch, has already reset it.

Things are not broken by the first patch, if I did not misunderstand.
