Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbXJLGrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbXJLGrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbXJLGrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:47:31 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:24827 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760124AbXJLGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:47:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vTCEPAuv/u2Gl63Z7cnPiqib3C9T3scUEbGrpMXdiCiLOPULwFcepKazwTjLgO8DJk5j6MaL8dRtFXV5nS2BU8AZBEp1GNRhkfeL2P1L7Z/8EopNi5XB/RbUocgYsAQ9gvVU5cQJXzQd3k2+wbDlp7k8ZP1x1eka6qHWCGXFCEM=  ;
X-YMail-OSG: LYuQSyMVM1kRfjT1yqcV_rzkvCULXfXa4ItP_aZyzWCExAjDSBvLgSZ98bvfKHanT.wSDZsQYrl92Q9fr_JLboiUaHrimZC5CICICvhIP1g6bKOUhFyME5d5QKIDiA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.23
Date: Fri, 12 Oct 2007 00:15:40 +1000
User-Agent: KMail/1.9.5
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <200710111916.23633.nickpiggin@yahoo.com.au> <20071012054615.GA22256@elte.hu>
In-Reply-To: <20071012054615.GA22256@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120015.40306.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 15:46, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > ;) I think you snipped the important bit:
> >
> > "the peak is terrible but it has virtually no dropoff and performs
> > better under load than the default 2.6.21 scheduler." (verbatim)
>
> hm, i understood that peak remark to be in reference to FreeBSD's
> scheduler (which the FreeBSD guys are primarily interested in
> obviously), not v2.6.21 - but i could be wrong.

I think the Linux peak has always been roughly as good as their
best FreeBSD ones (eg. http://people.freebsd.org/~jeff/sysbench.png).
Obviously in that graph, Linux sucks because of the malloc/mmap_sem
issue. It also shows what he is calling the terrible CFS peak, I
guess.

In my own tests, after that was fixed, Linux's peak got even a bit
higher, so that's the benchmark for performance.


> In any case, there is indeed a regression with sysbench and a low number
> of threads, and it's being fixed. The peak got improved visibly in
> sched-devel:
>
>   http://people.redhat.com/mingo/misc/sysbench-sched-devel.jpg
>
> but there is still some peak regression left, i'm testing a patch for
> that.

OK good. Once that's fixed, we'll hopefully be competitive with
FreeBSD again in this test :)
