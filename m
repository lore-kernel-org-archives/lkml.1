Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZKTJL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZKTJL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZKTJL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:11:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51168 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZKTJLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:11:55 -0500
Message-ID: <4B065D37.5080902@cn.fujitsu.com>
Date: Fri, 20 Nov 2009 17:11:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
References: <4B064AF5.9060208@cn.fujitsu.com> <20091120085536.GC19778@elte.hu>
In-Reply-To: <20091120085536.GC19778@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> ---
>>  tools/perf/Makefile       |    1 +
>>  tools/perf/builtin-kmem.c |  578 +++++++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/builtin.h      |    1 +
>>  tools/perf/perf.c         |   27 +-
>>  4 files changed, 594 insertions(+), 13 deletions(-)
>>  create mode 100644 tools/perf/builtin-kmem.c
> 
> btw., you might want to add it to command-list.txt as well (in a future 
> patch), so that 'kmem' shows up in the default 'perf' output.
> 
> Plus a Documentation/perf-kmem.txt file will make sure that 'perf help 
> kmem' and 'perf kmem --help' displays a help page, etc.
> 

I planed to do these after collecting comments and getting positive
responses. So sure, I'll post further patches.

