Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYIYNAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYIYNAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYIYM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:59:54 -0400
Received: from [198.145.64.141] ([198.145.64.141]:47689 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753515AbYIYM7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:59:54 -0400
Date: Thu, 25 Sep 2008 05:56:01 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925125601.GC6750@kroah.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com> <20080925024748.GG21049@yantp.cn.ibm.com> <20080925025550.GA15249@kroah.com> <48DB198C.1090207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB198C.1090207@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:54:36PM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
>> Well, having a config option like this isn't the way to go as it will be
>> forced on for all distros and users anyway.
>> A simple cpuid test is the easier way to do this, that's what the
>> userspace tools do, if it's really needed in the kernel.  But hopefully,
>> such things shouldn't be needed within the kernel as it's not Linux's
>> fault that the hypervisor has bugs in it :)
>> We wouldn't be wanting to work around bugs in Microsoft's hypervisor,
>> would we?
>
> We pretty much have to, just as we have to work around bugs in, say, AMD's 
> microcode.  We have avoided it so far, but it's gotten to a breaking point, 
> and rather than having ad hoc hacks scattered all over the place I want a 
> centralized test site setting a single global variable.

Ok, fair enough.

> Unfortunately, hypervisor vendors haven't adopted a uniform detection 
> scheme (CPUID level 0x40000000 is sometimes mentioned as a pseudo-standard, 
> but it's not universal, and not all virtualization solutions even can 
> override CPUID.)

Ah, I was hoping they were all doing this, as it seems the most "sane"
manner.  Good luck :)

greg k-h
