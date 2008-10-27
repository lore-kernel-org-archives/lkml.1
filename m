Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYJ0F53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYJ0F53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYJ0F5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:57:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYJ0F5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:57:21 -0400
Message-ID: <49055792.3040203@cn.fujitsu.com>
Date: Mon, 27 Oct 2008 13:54:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting	controller
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com> <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com>
In-Reply-To: <20081025060157.GA4614@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. I realized that defining init_cpuacct_group explicitly and statically
> isn't needed. I was just influenced by init_task_group and init_mem_cgroup.
> I guess those controllers have different reasons to have their init groups
> statically defined.
> 

I think one reason is, cpu_cgroup_subsys has to be initialized very early,
and at that time kmalloc() is not usable, so we use statically defined
init_task_group.
