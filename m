Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZHFF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZHFF4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZHFF4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:56:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZHFF4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:56:15 -0400
Message-ID: <4A7A70E5.2010204@redhat.com>
Date: Thu, 06 Aug 2009 13:57:57 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com> <m1ljlxsiox.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljlxsiox.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>>> No the crashdump mechanism is useless because user space is already
>>> broken and unusable.
>>>       
>> Again, why broken?
>>     
>
> To get a stock stat drive by hand I had to list about 5 kernel modules
> in the right magic order in /etc/kdump.conf
>
> Neither mount by label or mount by uuid when specified in /etc/kdump.conf
> I had to hack mkdumprd to get an initrd that even finds the proper disk
> to mount.
>   

You are saying that there is some difficulty to make a initrd for kdump, 
but I am sorry that I can't see any relations between this and my patch. 
What is your point here?

