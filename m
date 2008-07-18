Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYGRCiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYGRCiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYGRCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:38:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbYGRCih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:38:37 -0400
Message-ID: <488001BF.1070006@cn.fujitsu.com>
Date: Fri, 18 Jul 2008 10:36:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com, peterz@infradead.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain level
References: <487EFDD0.2060101@cn.fujitsu.com> <20080717152833.1e14a1c4.pj@sgi.com>
In-Reply-To: <20080717152833.1e14a1c4.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Li Zefan wrote:
>> When multiple cpusets are overlapping in their 'cpus' and hence they
>> form a single sched domain, the largest sched_relax_domain_level among
>> those should be used. But when top_cpuset's sched_load_balance is
>> set, its sched_relax_domain_level is used regardless other sub-cpusets'.
> 
> This code has gotten too complicated for my modest brain ;).
> 
> Question:
> 
>     In the case that the top_cpuset's sched_load_balance is -not- set,
>     is there code already present that sets the sched_relax_domain_level
>     in overlapping cpusets to the largest value in any of the overlapping
>     cpusets?
> 
>     If so, where is that code?
> 

It was your idea to use the largest sched_load_balance for overlapping cpusets.
;)

