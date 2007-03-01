Return-Path: <linux-kernel-owner+w=401wt.eu-S1161065AbXCAWkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065AbXCAWkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXCAWkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:40:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXCAWkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:40:41 -0500
Message-ID: <45E75635.3070103@redhat.com>
Date: Thu, 01 Mar 2007 16:39:49 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: nscott@aconex.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com>	 <20070225022326.137b4875.akpm@linux-foundation.org>	 <20070301183445.GA7911@amitarora.in.ibm.com>	 <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge>
In-Reply-To: <1172788855.26078.294.camel@edge>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Scott wrote:
> On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
>> On Fri, 2 Mar 2007 00:04:45 +0530
>> "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>>
>>> This is to give a heads up on few patches that we will be soon coming up
>>> with. These patches implement a new system call sys_fallocate() and a
>>> new inode operation "fallocate", for persistent preallocation. The new
>>> system call, as Andrew suggested, will look like:
>>>
>>>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>> ...
>>
>> I'd agree with Eric on the "command" flag extension.
> 
> Seems like a separate syscall would be better, "command" sounds
> a bit ioctl like, especially if that command is passed into the
> filesystems..
> 
> cheers.
> 

I'm fine with that too, I'd just like the functionality :)

-Eric
