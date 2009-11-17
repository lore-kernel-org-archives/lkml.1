Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZKQR1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZKQR1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZKQR1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:27:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55961 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZKQR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:27:11 -0500
Message-ID: <4B02DCE4.1080509@us.ibm.com>
Date: Tue, 17 Nov 2009 09:27:00 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Michel Lespinasse <walken@google.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <20091117172456.GA14749@elte.hu>
In-Reply-To: <20091117172456.GA14749@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Tue, 2009-11-17 at 09:18 +0100, Ingo Molnar wrote:
>>> Would you be interested in adding it as a 'perf bench futex' testcase? 
>>> That way kernel developers could monitor futex performance in the future 
>>> as well.
>>>
>>> See 'perf bench' in the latest perf events tree:
>>>
>>>   http://people.redhat.com/mingo/tip.git/README
>>>
>>> Do 'cd tools/perf; make -j install' to install perf.
>> Darren has recently been putting a lot of effort in making a futex test
>> suite:
>>
>> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
>>
>> Its not yet complete, but hopefully it will soon be :-)
> 
> Looks nice! Any futex performance measurements within it could be added 
> to perf bench - with standardized options and output, etc.
> 
> 	Ingo

I'll take a look at perf this week and see what would be required to 
share (?) tests between perf and futextest.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
