Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbZHTBJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbZHTBJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZHTBJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:09:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64000 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZHTBJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:09:27 -0400
Message-ID: <4A8CA1EF.6000305@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 09:07:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 15/16] tracing: Add fields format definition for	syscall
 events
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <1250016545-6601-16-git-send-email-fweisbec@gmail.com> <4A8C3290.3070900@redhat.com> <20090819173734.GG4972@nowhere>
In-Reply-To: <20090819173734.GG4972@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, I have yet to fix this, that because syscalls that have no parameters
> raise a small bug in the return value of trace_seq_printf() while printing
> their format, returning 0 as if the buffer was full and lost some bits.
> 
> However, It's possible that the last patches from Li fix this, since he did
> a total/better refactoring of the format definition for syscall events.
> 
> I'll check this,

I was not aware of this bug, and the bug is still there, but it's
easy to fix and I've fixed it. Will send out the patch soon.

