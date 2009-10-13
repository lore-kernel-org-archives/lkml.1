Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbZJMJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbZJMJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZJMJZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:25:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZJMJZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:25:28 -0400
Message-ID: <4AD4471B.7000200@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 17:23:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/profile: Add filter support
References: <4AD3E34C.1020301@cn.fujitsu.com>	 <4AD3E3B5.70502@cn.fujitsu.com> <1255425377.8392.156.camel@twins>
In-Reply-To: <1255425377.8392.156.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-10-13 at 10:19 +0800, Li Zefan wrote:
>> +#ifdef CONFIG_EVENT_PROFILE
>> +       struct event_filter             *filter;
>> +       int                             filter_active;
>>  #endif
> 
> Why do you need filter_active, isn't !filter equivalent?
> 

Indeed. I realized this right after I sent out this patchset. I'll
fix it. Thanks.

