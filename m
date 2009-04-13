Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZDMAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZDMAmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 20:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZDMAmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 20:42:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbZDMAmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 20:42:15 -0400
Message-ID: <49E28A94.1050700@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 08:43:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com> <49E051B9.8060805@cn.fujitsu.com> <20090412130727.GC20281@elte.hu> <20090412131028.GT5178@kernel.dk> <20090412133714.GB384@elte.hu>
In-Reply-To: <20090412133714.GB384@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>> On Sun, Apr 12 2009, Ingo Molnar wrote:
>>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>
>>>> Hi Ingo,
>>>>
>>>> I would like to ask what's the status of these 2 patches.
>>>>
>>>> Arnaldo acked on them.
>>> They looked good to me - but i'm waiting for an Ack from Jens. Jens 
>>> has complained about seeing un-ack-ed patches in the blktrace code, 
>>> so i've started serializing any new patches on acks from Jens. The 
>>> workflow would be more efficient i suspect if Jens 
>>> nominated/declared you and Arnaldo as blktrace co-maintainers too - 
>>> most of the patches come from you two.
>> I'd be fine with listing Li Zefan as co-maintainer of the blktrace 
>> bits. He knows what he is doing and is also a user of blktrace, so 
>> I think he would be fine. Li, what do you think?
> 
> Cool ... i've also taken this as an implicit approval from you of Li 
> sending blktrace patches so i have queued the two up.
> 

Thanks!

> The next big (and nice!) step would be the blktrace events in 
> TRACE_EVENT() style. That would integrate the blktrace tracepoints 
> with all the others, in one coherent framework.
> 

As I mentioned in another mail thread, this is what we are planning
to do. :)

--
Zefan
