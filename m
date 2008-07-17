Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbYGQU2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbYGQU2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbYGQU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:28:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43904 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759655AbYGQU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:28:35 -0400
Date: Thu, 17 Jul 2008 15:28:33 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com, peterz@infradead.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain
 level
Message-Id: <20080717152833.1e14a1c4.pj@sgi.com>
In-Reply-To: <487EFDD0.2060101@cn.fujitsu.com>
References: <487EFDD0.2060101@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> When multiple cpusets are overlapping in their 'cpus' and hence they
> form a single sched domain, the largest sched_relax_domain_level among
> those should be used. But when top_cpuset's sched_load_balance is
> set, its sched_relax_domain_level is used regardless other sub-cpusets'.

This code has gotten too complicated for my modest brain ;).

Question:

    In the case that the top_cpuset's sched_load_balance is -not- set,
    is there code already present that sets the sched_relax_domain_level
    in overlapping cpusets to the largest value in any of the overlapping
    cpusets?

    If so, where is that code?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
