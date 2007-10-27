Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXJ0TEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXJ0TEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXJ0TEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:04:12 -0400
Received: from main.gmane.org ([80.91.229.2]:33573 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbXJ0TEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:04:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.24-rc1: First impressions
Date: Sat, 27 Oct 2007 15:14:19 -0400
Message-ID: <47238E0B.2010601@tmr.com>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>	<20071026152221.GA26619@elte.hu>	<20071026122155.45ce72e7.akpm@linux-foundation.org>	<20071026193339.GA21799@elte.hu> <20071026124252.aba97af4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, spamtrap@knobisoft.de,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       wfg@mail.ustc.edu.cn, torvalds@linux-foundation.org, riel@redhat.com
X-Gmane-NNTP-Posting-Host: pool-70-109-100-63.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20071026124252.aba97af4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 26 Oct 2007 21:33:40 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>

>> so a final 'sync' should be added to the test too, and the time it takes 
>> factored into the bandwidth numbers?
> 
> That's one way of doing it.  Or just run the test for a "long" time.  ie:
> much longer than (total-memory / disk-bandwidth).  Probably the latter
> will give a more accurate result, but it can get boring.
> 
Longer might be less inaccurate, but without flushing the last data you 
really don't get best accuracy, you just reduce the error. Clearly doing 
fdatasync() is best, since other i/o caused by sync() can skew the results.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

