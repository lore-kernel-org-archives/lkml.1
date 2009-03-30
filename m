Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZC3AkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZC3AkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZC3AkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:40:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZC3AkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:40:09 -0400
Message-ID: <49D014F9.8000404@cn.fujitsu.com>
Date: Mon, 30 Mar 2009 08:40:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] blktrace: last round of fixes
References: <49CC6691.7050103@cn.fujitsu.com> <20090328224640.GA2465@elte.hu>
In-Reply-To: <20090328224640.GA2465@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This is the last round of fixes for blktrace, I hope.  :) 
>>
>> Changelog v1 -> v2:
>>   - fix a bug in "blktrace: make classic output more classic",
>>     and rebase other patches.
>>   - re-order patches.
>>   - a new patch for filtering BLK_TN_MESSAGE
>>
>> [PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
>> [PATCH v2 2/6] blktrace: make classic output more classic
>> [PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
>> [PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace
>> [PATCH v2 5/6] blktrace: extract duplidate code
>> [PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly
>> ---
>>  blktrace.c     |  188 +++++++++++++++++++++++++++++++++------------------------
>>  trace_output.c |    6 -
>>  trace_output.h |    5 -
>>  3 files changed, 117 insertions(+), 82 deletions(-)
> 
> Li, Jens - what's your call for v2.6.30, can the blktrace changes go 
> upstream or should i zap the whole thing?
> 

It should be find to merge tip/blktrace into .30, and we still have 2
month to fix remaining bugs, if any.

> There are no new -tip test failures here so it's green as far as i'm 
> concerned. It's holding up the tracing tree so we need to decide one 
> way or another.
> 
