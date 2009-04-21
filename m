Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZDUUAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZDUUAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZDUUA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:00:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZDUUAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:00:25 -0400
Message-ID: <49EE25CB.6070709@redhat.com>
Date: Tue, 21 Apr 2009 23:00:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com> <49EE2497.3060009@codemonkey.ws>
In-Reply-To: <49EE2497.3060009@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>>>
>>> So Avi, regardless of what interface is chosen for KVM, can you hold 
>>> off applying these patches until there is a TCG implementation?  
>>> Otherwise, we'll be playing catchup between kvm-userspace and 
>>> upstream QEMU forever.
>>
>> I have a feeling we will anyway,
>
> Not if we avoid committing things to kvm-userspace that would require 
> major reworking to get into upstream QEMU.  Fixing these issues is 
> much easier up front then down the road.
>

No argument.  But some kernel features will require major rework in qemu 
before we can support them properly.  We'll still want to bring them to 
users quickly so users can enjoy them (and we can enjoy users testing 
them).  Waiting for a qemu rework may take a while, and we'll lose 
valuable feedback.

For this kind of work, we can provide kvm-userspace.git as a kind of 
playground where these experiments may be made.  kvm-userspace.git 
exists to support kvm.git; while qemu.git has a life of its own and more 
stringent barriers to acceptance.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

