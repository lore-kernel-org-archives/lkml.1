Return-Path: <linux-kernel-owner+w=401wt.eu-S934451AbZLPBeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451AbZLPBeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934428AbZLPBeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:34:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49817 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934418AbZLPBeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:34:10 -0500
Message-ID: <4B2838A7.7020509@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 09:32:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf_event: fix getting point
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <20091215135855.GA5833@nowhere> <4B2831F3.1040001@cn.fujitsu.com> <20091216012219.GD8423@nowhere>
In-Reply-To: <20091216012219.GD8423@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:

>> We can't do it in x86_32:
>> error: cast to pointer from integer of different size
> 
> 
> You can just do:
> 
> ptr = (void *)(unsigned long)value;
> 

Yeah, i forget this, it work well both in 32/64 machine.

Thanks,
Xiao
