Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZK0Ahx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZK0Ahx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZK0Ahw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:37:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60707 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZK0Ahv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:37:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0F1F42.50509@jp.fujitsu.com>
Date: Fri, 27 Nov 2009 09:37:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH -tip 1/3] introduce task_times() to replace task_{u,s}time()
 pair
References: <4B061E9A.8040100@jp.fujitsu.com>	 <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>	 <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>	 <4B0E16AE.906@jp.fujitsu.com> <1259231144.4273.27.camel@twins>
In-Reply-To: <1259231144.4273.27.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 14:48 +0900, Hidetoshi Seto wrote:
>> This patch introduces a function task_times(*tsk, *utime, *stime)
>> to retrieve utime and stime at once in better, optimized way.
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> OK, the patch looks good, but it does not solve those non monotonic
> times funnies that started all this, right?

Yes, you are right.
These three patches are cleanup, not bugfix.

I don't have any clear idea to solve the original issue yet...


Thanks,
H.Seto


