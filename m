Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbXGLFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbXGLFfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXGLFfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:35:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:37199 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXGLFfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:35:39 -0400
Message-ID: <4695BDA9.7070104@qumranet.com>
Date: Thu, 12 Jul 2007 08:35:37 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KVM Updates for 2.6.23-rc1
References: <11841377191653-git-send-email-avi@qumranet.com> <46955465.8080207@redhat.com>
In-Reply-To: <46955465.8080207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 12 Jul 2007 08:35:37 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/11/2007 03:08 AM, Avi Kivity wrote:
>   
>> Linus, please do your usual thing from the repository and branch at
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>>
>> This contains kvm updates for the 2.6.23 merge window, including
>>
>>  - performance improvements
>>  - suspend/resume fixes
>>  - guest smp
>>  - random fixes and cleanups
>>
>>     
>
> What version of KVM does this update contain? I can't find any place
> in the code with version number.
>   

There is an ABI version number (now at 12) in include/linux/kvm.h.  That
means any version of kvm userspace from kvm-22  upwards can be used. 
Since the ABI will not change anymore except in a backward compatible
manner, the old concerns of matching userspace to kernel are gone.

In terms of parity with the external kernel module, 2.6.23-rc1 will be
very similar to kvm-29.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

