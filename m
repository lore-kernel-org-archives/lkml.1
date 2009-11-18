Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZKRF3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZKRF3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZKRF3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:29:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44381 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZKRF3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:29:32 -0500
Message-ID: <4B03863E.1070602@us.ibm.com>
Date: Tue, 17 Nov 2009 21:29:34 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com> <20091118033741.GB23808@google.com>
In-Reply-To: <20091118033741.GB23808@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> On Tue, Nov 17, 2009 at 08:16:06AM -0800, Darren Hart wrote:
>>> Darren has recently been putting a lot of effort in making a futex test
>>> suite:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
>>>
>>> Its not yet complete, but hopefully it will soon be :-)
>> Michael, would you be willing to include a version of this test in the  
>> above test suite? If so, then in keeping with the rest of the test suite, 
>> I would recommend splitting into two tests, one of each opcode being 
>> tested, and  add argument to define thread count. The run.sh script would 
>> then run each thread count as a separate test run.
> 
> I had a quick look at the tree (using the http interface). I sure would not
> mind adding the tests, and the futextest.h file would make them look
> quite cleaner than my previous version. Just to be sure, would you put them
> under performance/ or stress/ ? This would be the first test to be added
> in these directories in any case, right ? (just asking in case I missed
> something obvious).

Michel, excellent!

I think performance sounds like the right place to me. Performance is 
where I plan to put measurement tests where you report some score. 
Stress tests are considered to have passed if the run to completion 
without locking up or crashing the kernel :-)

We should take a look at the perf tool to see what requirements it may 
impose on tests we want to share between perf and futextest.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
