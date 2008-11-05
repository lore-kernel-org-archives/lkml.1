Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYKEDee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYKEDee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYKEDeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:34:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59053 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYKEDeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:34:22 -0500
Message-ID: <49111394.1070304@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 11:31:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting	controller
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com> <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com>
In-Reply-To: <20081030171622.GA19872@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> cpuacct was designed to count cpu usage of a group of tasks, and now some people
>> want it to also take child group's usage into account, so I think this is a feature
>> request but not a bug fix.
>>
> 
> I disagree. The child is a part of the parent's hierarchy, and therefore
> its usage should reflect in the parent's usage.
> 

In memcg the child's usage doesn't reflect in its parent's usage. ;)

Balbir just posted a patchset to add hierarchy support in memcg, and added memory.feature
to disable/enable this feature. Is it for performance only or also for keeping the user
interface/behavior unchanged?
