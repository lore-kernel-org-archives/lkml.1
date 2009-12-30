Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZL3Jox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZL3Jox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZL3Jow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:44:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:50067 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZL3Jov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:44:51 -0500
Message-ID: <4B3B1D6C.8050006@windriver.com>
Date: Wed, 30 Dec 2009 17:29:16 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf tools: remove pid option from stat
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com> <1262075829-16257-2-git-send-email-liming.wang@windriver.com> <1262088251.7135.131.camel@laptop> <20091230092327.GA10486@elte.hu>
In-Reply-To: <20091230092327.GA10486@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2009 09:44:00.0325 (UTC) FILETIME=[9D43C750:01CA8934]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Tue, 2009-12-29 at 16:37 +0800, Liming Wang wrote:
>>> pid option is useless for stat, so remove it.
>> Hmm, it shouldn't be.. and instead of removing it I would suggesting fixing 
>> this.
> 
> Yes. For exampe something like:
> 
>   perf stat --repeat 10 --pid $(pidof firefox) sleep 1
> 
> Should show firefox's resource usage sampled over 10 seconds.
> 
> If this doesnt work it should be fixed. Plus i suspect we should allow:
> 
>   perf stat --pid $(pidof firefox)
> 
> to run until Ctrl-C - like perf record allows.
Yes, perf record works well with "--pid".
I think stat can borrow come code from record.
Please discard this patch.

Liming Wang
> 
> 	Ingo
> 

