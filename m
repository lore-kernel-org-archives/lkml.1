Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbXGKFTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbXGKFTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbXGKFTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:19:04 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:28999 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757963AbXGKFTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:19:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=L/meW7EboFj0aYpyLFnqw6tDCb1yvqI5kKDtWHhOADzp2rjoAf7VQH2p6HPNO9ePYilPei2IMBcfbRYNkrvQGJcpSJcSISw+dyUEPolLl682mZXeR5Aa8339zxnioQCmgp0xUJm6FdAA3i8SLJEi9zfLvRikMqKJ0U2kPZqGCfU=  ;
X-YMail-OSG: yoWo1foVM1mFy_ZD3w_juYUI1fz3r8a5P3i71fpcTv.G5wx.l0PimYkTW4oMB1ieh.WeAUfpSA--
Message-ID: <4694683B.3060705@yahoo.com.au>
Date: Wed, 11 Jul 2007 15:18:51 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matthew Hawkins <darthmdh@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org> <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>
In-Reply-To: <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hawkins wrote:
> On 7/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:

> Anyhow with swap prefetch, applications that may have been sitting
> there idle for a while become responsive in the single-digit seconds
> rather than double-digit or worse.  The same goes for a morning wakeup
> (ie after nightly cron jobs throw things out)

OK that's a good data point. It would be really good to be able to
do an analysis on your overnight IO patterns and the corresponding
memory reclaim behaviour and see why things are getting evicted.

Not that swap prefetching isn't a good solution for this situation,
but the fact that things are getting swapped out for you also means
that mapped files and possibly important pagecache and dentries are
being flushed out, which we might be able to avoid.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
