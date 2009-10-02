Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZJBS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZJBS5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZJBS5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:57:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:44204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753143AbZJBS5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:57:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+X3DA2A1eXyIKHzyvIjJ3fXe66mjsR+UdCzmG5r0
	Qc1qLW/KZoL1F+
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091002181903.GN31616@kernel.dk>
References: <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	 <20091002145610.GD31616@kernel.dk>
	 <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 20:57:18 +0200
Message-Id: <1254509838.8667.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:

> I'm not too worried about the "single IO producer" scenarios, and it
> looks like (from a quick look) that most of your numbers are within some
> expected noise levels. It's the more complex mixes that are likely to
> cause a bit of a stink, but lets worry about that later. One quick thing
> would be to read eg 2 or more files sequentially from disk and see how
> that performs.

Hm.  git(s) should be good for a nice repeatable load.  Suggestions?

> If you could do a cleaned up version of your overload patch based on
> this:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> 
> then lets take it from there.

I'll try to find a good repeatable git beater first.  At this point, I
only know it helps with one load.

	-Mike

