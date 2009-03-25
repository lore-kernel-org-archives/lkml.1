Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZCYCyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZCYCyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZCYCyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:54:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZCYCym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:54:42 -0400
Message-ID: <49C99D0C.9070905@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 10:55:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <alpine.DEB.2.00.0903241148240.22830@gandalf.stny.rr.com> <20090324155609.GA10365@elte.hu> <alpine.DEB.2.00.0903241202440.22830@gandalf.stny.rr.com> <alpine.DEB.2.00.0903241205320.22830@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903241205320.22830@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm really confused now. The prototype for blk_trace_str2mask has 
>> two parameters. It is used with two parameters above, but then it is used 
>> here with only one parameter. The blk_str2act_mask may have one, and that 
>> is what is replaced.
>>
>> What am I missing?
> 
> I'm dyslexic :-p
> 
> I see now...
> 
> The proto-type is blk_trace_mask2str
> 
> but this is blk_trace_str2mask
> 
> Nevermind,
> 

Never mind, your review is always appreciated. :)

