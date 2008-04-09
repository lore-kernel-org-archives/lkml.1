Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYDININ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYDININ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYDINID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:08:03 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:49744 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYDINIB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:08:01 -0400
Date: Wed, 9 Apr 2008 14:07:57 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, skumar@linux.vnet.ibm.com
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080409130757.GA11650@deepthought>
References: <20080403191916.GA30864@deepthought> <20080404143701.GA13042@linux.vnet.ibm.com> <20080404153232.GC21753@deepthought> <20080405144042.GB24075@linux.vnet.ibm.com> <20080405210347.GA19097@deepthought> <20080406234833.GA12131@deepthought> <20080408085027.GB13042@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080408085027.GB13042@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 02:20:27PM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Apr 07, 2008 at 12:48:33AM +0100, Ken Moffat wrote:
> >  Well, I found your analysis convincing.  Unfortunately, my hardware
> > disagreed.  Testing -rc8 with CONFIG_GROUP_SCHED disabled (a test is
> > a mixture of 5 attempts to restart and 5 to shutdown):
> > 
> > 1. the base version success is 4/10
> > 
> > 2. increasing the granularity by a factor of 10 as you requested,
> > success is 8/10
> 
> This makes me think that we are just exposing a timing related problem
> in gdm here.
> 
> How abt a larger factor?
> 
> 	# echo 200000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> 
> Does that make it 10/10 ?!
> 
[ snipping the suggestion to run strace, I've already sent the
results off-list ]

 Yes, it does.  Seems to run adequately too (a little audio playback,
a little you-tube, some untarring and compiling).  Understanding the
real problem would be nice, but for me this seems to be an adequate
work-around.  This is with CONFIG_GROUP_SCHED turned off.

Thanks

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
