Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZDUUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZDUUpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZDUUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:45:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbZDUUpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:45:20 -0400
Message-ID: <49EE304D.5060108@redhat.com>
Date: Tue, 21 Apr 2009 23:45:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws> <49EE25CB.6070709@redhat.com> <49EE27C2.3060505@codemonkey.ws>
In-Reply-To: <49EE27C2.3060505@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>> No argument.  But some kernel features will require major rework in 
>> qemu before we can support them properly.  We'll still want to bring 
>> them to users quickly so users can enjoy them (and we can enjoy users 
>> testing them).  Waiting for a qemu rework may take a while, and we'll 
>> lose valuable feedback.
>
> Then we're failing.  If a particular implementation of a feature is 
> acceptable for kvm-userspace users, and we don't take it in QEMU 
> without requiring a huge amount of different work, then it suggests 
> something is broken about the QEMU process.
>

Example: SMP.
Example: vlan API.

>> For this kind of work, we can provide kvm-userspace.git as a kind of 
>> playground where these experiments may be made.  kvm-userspace.git 
>> exists to support kvm.git; while qemu.git has a life of its own and 
>> more stringent barriers to acceptance.
>
> As long as people are using kvm-userspace.git instead of qemu.git, 
> we're failing IMHO.  If kvm-userspace.git is basically the equivalent 
> of the x86 git kernel tree, linux-next, or something like that, then 
> that's a good thing.

That's definitely a long term goal, but qemu is not yet at a point where 
it is easy to implement new features efficiently.  Once it reaches that 
state, kvm-userspace will become a simple staging ground (or even 
disappear entirely).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

