Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZG2VZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZG2VZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZG2VZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:25:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZG2VZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:25:10 -0400
Date: Wed, 29 Jul 2009 23:21:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: + cpu_hotplug-dont-affect-current-tasks-affinity.patch added
	to -mm tree
Message-ID: <20090729212125.GA16970@redhat.com>
References: <20090729023302.GA8899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729023302.GA8899@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add more CCs)

On 07/29, Oleg Nesterov wrote:
>
> But can't we make a much more simple patch ?
>
> Why should we play with set_cpus_allowed() at all? We can just migrate
> the caller of _cpu_down() before other tasks, right after take_cpu_down()
> does __cpu_disable()->remove_cpu_from_maps().
>
> No?
>
> Oleg.
>
> ------------------------------------------------------------------------
> Uncompiled, and we need to export move_task_off_dead_cpu(). Just to
> explain what I mean.

OK, tested. I think this should work. But first we should fix the bug
with cpusets. I'll send the patch in a minute...

Oleg.

