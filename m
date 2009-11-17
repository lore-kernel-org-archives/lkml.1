Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZKQQQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZKQQQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZKQQQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:16:38 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41664 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZKQQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:16:37 -0500
Message-ID: <4B02CC46.4020506@us.ibm.com>
Date: Tue, 17 Nov 2009 08:16:06 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop>
In-Reply-To: <1258448121.7816.29.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-11-17 at 09:18 +0100, Ingo Molnar wrote:
>> Would you be interested in adding it as a 'perf bench futex' testcase? 
>> That way kernel developers could monitor futex performance in the future 
>> as well.
>>
>> See 'perf bench' in the latest perf events tree:
>>
>>   http://people.redhat.com/mingo/tip.git/README
>>
>> Do 'cd tools/perf; make -j install' to install perf.
> 
> Darren has recently been putting a lot of effort in making a futex test
> suite:
> 
> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
> 
> Its not yet complete, but hopefully it will soon be :-)
> 

Michael, would you be willing to include a version of this test in the 
above test suite? If so, then in keeping with the rest of the test 
suite, I would recommend splitting into two tests, one of each opcode 
being tested, and  add argument to define thread count. The run.sh 
script would then run each thread count as a separate test run.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
