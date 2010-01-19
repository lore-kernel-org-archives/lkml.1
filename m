Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574Ab0ASOYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0ASOYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296Ab0ASOYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:24:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab0ASOYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:24:23 -0500
Message-ID: <4B55C125.6040602@redhat.com>
Date: Tue, 19 Jan 2010 09:26:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer	operation
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com> <20100118172021.GL10364@nowhere> <4B549F00.6060704@redhat.com> <4B550A32.6010508@cn.fujitsu.com> <20100119085958.GB5145@nowhere>
In-Reply-To: <20100119085958.GB5145@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 19, 2010 at 09:26:10AM +0800, Xiao Guangrong wrote:
>>> Actual filling buffer is done in the profile handlers,
>>> so I think ftrace_perf_buf_prepare() may be better :-)
>>> ftrace_perf_buf_submit is good to me:-)
>>>
>>
>> OK, i'll rename those functions and add __kprobe for ftrace_perf_buf_prepare(),
>> i guess i can add you Acked-by :-)
> 
> 
> You can add mine yeah (couldn't tell for Masami).

Sure, add mine too, because other parts look good for me. :-)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

