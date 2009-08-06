Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZHFCEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZHFCEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZHFCEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:04:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZHFCEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:04:36 -0400
Message-ID: <4A7A3A78.7080200@redhat.com>
Date: Thu, 06 Aug 2009 10:05:44 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org> <m1skg5vpgg.fsf@fess.ebiederm.org>
In-Reply-To: <m1skg5vpgg.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Neil Horman <nhorman@redhat.com> writes:
>   
>> You could of
>> course boot the installer kernel with a crashkernel line pre-selected  suppose,
>> but then you have to go to the trouble of figuring that allocation size out each
>> time.  This gives you a nice convienent way to get a reasonable block of memory
>> without the need to do all that extra work.
>>     
>
> My big concern is that you are moving policy into the kernel, when it isn't at
> all clear that policy is the right thing to do, and the existing mechanisms give
> you enough rope to do this all in userspace.
>   


How? This doesn't remove the existing mechanism, just provides a new 
choice for user like me who doesn't know how much memory should be 
reserved, or who simply doesn't want to concern this since he/she has 
very enough memory.

> You also have to build (or at least load) the whole kdump image after
> the system boots, and configure someplace for this to be saved.
>
> What class of problems do you expect to catch with this?
>   

Again, try to save the user from choosing numbers for "crashkernel=".
> What has me puzzled is that the mkdumprd that ships with fedora isn't
> usable without patching, and it seems to be steadily getting worse.  

Please explain why it is not usable? The patch won't break the 
userspace, since it modifies the "crashkernel=" command line dynamically.

Thanks.

