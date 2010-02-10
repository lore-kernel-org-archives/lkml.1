Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0BJKtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:49:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54235 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0BJKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oMrPs9QzZUfcozv57FZEhzIvvLIyFzbdh2Nj1gqVMDt4DoqR/SJ0IJHj410DX1EnQ3
         Dpx73uYFzsBZ9iC8FtpC/xY8UWnR7ozGhYV6V4k2enoAAa+t1+83QOzEySZtG9HwdAJM
         I2CxUcQgjXh1kWyFOjTMKBTTm6FKtZvyQXrTs=
Date: Wed, 10 Feb 2010 11:49:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100210104915.GC5035@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265193196.24455.390.camel@laptop> <20100203220735.GD5068@nowhere> <1265562627.12224.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265562627.12224.99.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 06:10:27PM +0100, Peter Zijlstra wrote:
> One thing we could do is add a PERF_TYPE_COLLECTION and have its read()
> method do something else than regular counters would, that way we can
> use read()/lseek()/stat() fd interface. The only trouble with that is
> that doesn't use the 'regular' output buffer.


But would be nice too. The drawback is indeed a separation/implementation
treatment against other events.


> /me goes try and come up with yet another solution..


Not sure there is another solution than the above or an inject/mmap
thing.

