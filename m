Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYJ3Hqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYJ3Hqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYJ3Hqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:46:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbYJ3Hqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:46:45 -0400
Message-ID: <490965B0.8090707@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 15:43:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix invalid cgrp->dentry before cgroup has been
 completely removed
References: <490960EF.7020500@cn.fujitsu.com> <20081030003226.33bad22a.akpm@linux-foundation.org>
In-Reply-To: <20081030003226.33bad22a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 30 Oct 2008 15:23:27 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This fixes oops when reading /proc/sched_debug.
> 
> In which kernel versions?  The patch applies to 2.6.27 - should it be
> aplied to 2.6.27.x?  Earlier?
> 

I think the bug exists both in 2.6.26 and 2.6.27, but I don't know if we should
apply the patch to these 2 versions. sched_debug is a debug feature.


