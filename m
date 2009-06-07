Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZFGKcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZFGKcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZFGKb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:31:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbZFGKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:31:56 -0400
Message-ID: <4A2B9713.3050407@redhat.com>
Date: Sun, 07 Jun 2009 13:31:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] KVM: Add VT-x machine check support v2
References: <20090605232356.GA7091@basil.nowhere.org> <4A2B57B9.7070207@redhat.com> <20090607103514.GA22266@one.firstfloor.org>
In-Reply-To: <20090607103514.GA22266@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jun 07, 2009 at 09:01:29AM +0300, Avi Kivity wrote:
>   
>>> v2: Handle machine checks still in interrupt off context
>>> to avoid problems on preemptible kernels.
>>>
>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>>
>>>  
>>>       
>> Only applies with -C0.  What tree was this generated against?
>>     
>
> 2.6.30-rc7
>
>   

Please use kvm.git, which is maybe 150 patches ahead.

>> Please diff and test against latest kvm.git.
>>     
>
> Sorry can't do neither for the next two weeks.
>   

Ying?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

