Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYKJNNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYKJNNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYKJNNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:13:35 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:55613 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYKJNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:13:34 -0500
Message-ID: <491831AD.4050207@linux.vnet.ibm.com>
Date: Mon, 10 Nov 2008 18:35:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: bharata@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
References: <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com> <1226312561.2697.4093.camel@twins>
In-Reply-To: <1226312561.2697.4093.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-11-04 at 18:19 +0530, Bharata B Rao wrote:
> 
>> Add hierarchical accounting to cpu accounting controller and cpuacct
>> documentation.
>>
>> Currently, while charging the task's cputime to its accounting group,
>> the accounting group hierarchy isn't updated. This patch charges the cputime
>> of a task to its accounting group and all its parent accounting groups.
>>
>> Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>> Reviewed-by: Paul Menage <menage@google.com>
> 
> Seems sane and simple enough.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Just in case it was missed

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
