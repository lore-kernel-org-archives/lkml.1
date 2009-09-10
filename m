Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZIJBU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZIJBU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZIJBU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:20:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64244 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbZIJBU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:20:57 -0400
Message-ID: <4AA8542F.7000909@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 09:19:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] tracing: Clean up trace.h
References: <4AA7517C.2070009@cn.fujitsu.com> <1252510634.27001.22.camel@gandalf.stny.rr.com>
In-Reply-To: <1252510634.27001.22.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-09-09 at 14:55 +0800, Li Zefan wrote:
>> - remove some dead code
>> - remove @stats from struct tracer
>> - move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
>>   to kernel/trace/trace_events_filter.c
> 
> Thanks Li, I'll apply it. Just curious, do you have a tool to find dead
> code, or is it just by review?
> 

No, no tool, otherwise I would have run it on the whole kernel
tree and made tons of patches. ;)

