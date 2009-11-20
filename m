Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZKTIHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZKTIHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZKTIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:07:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZKTIHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:07:20 -0500
Message-ID: <4B064E15.9010708@cn.fujitsu.com>
Date: Fri, 20 Nov 2009 16:06:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] [PATCH 2/4] tracing: Create new TRACE_EVENT_TEMPLATE
References: <20091119171003.929771398@goodmis.org> <20091119171106.611553083@goodmis.org>
In-Reply-To: <20091119171106.611553083@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> There are some places in the kernel that define several tracepoints and
> they are all identical besides the name. The code to enable, disable and
> record is created for every trace point even if most of the code is
> identical.
> 
> This patch adds TRACE_EVENT_TEMPLATE that lets the developer create
> a template TRACE_EVENT and create trace points with DEFINE_EVENT, which
> is based off of a given template. Each trace point used by this
> will share most of the code, and bring down the size of the kernel
> when there are several duplicate events.
> 

Great!

There are quite many places that this template can be used.

If you haven't planed to convert other TRACE_EVENTs, I'll take it.

More over, I'll cook another patch to annotate some functions as
__init, so shrink the kernel size further.

