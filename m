Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbYD3IiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbYD3IiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYD3Ih5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:37:57 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:12127
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYD3Ihz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:37:55 -0400
Message-ID: <48182F7F.9000400@qumranet.com>
Date: Wed, 30 Apr 2008 11:36:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>, git@vger.kernel.org
Subject: Re: small author mixup 
References: <1209310768-12322-1-git-send-email-avi@qumranet.com> <200804301012.05179.borntraeger@de.ibm.com>
In-Reply-To: <200804301012.05179.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Sonntag, 27. April 2008 schrieb Avi Kivity:
>   
>> Carsten Otte (4):
>>       s390: KVM preparation: provide hook to enable pgstes in user pagetable
>>       KVM: s390: interrupt subsystem, cpu timer, waitpsw
>>       KVM: s390: API documentation
>>       s390: KVM guest: detect when running on kvm
>>
>> Christian Borntraeger (10):
>>       KVM: kvm.h: __user requires compiler.h
>>       s390: KVM preparation: host memory management changes for s390 kvm
>>       s390: KVM preparation: address of the 64bit extint parm in lowcore
>>       KVM: s390: sie intercept handling
>>       KVM: s390: intercepts for privileged instructions
>>       KVM: s390: interprocessor communication via sigp
>>       KVM: s390: intercepts for diagnose instructions
>>       KVM: s390: add kvm to kconfig on s390
>>       KVM: s390: update maintainers
>>       s390: KVM guest: virtio device support, and kvm hypercalls
>>     
>
> Thats interesting, some of these patches should actually be credited to 
> Carsten - and in fact on kvm.git master they are credited to Carsten.
>
> I think the problem is, that these patches contained multiple From lines. On 
> kvm.git the first line (Carsten) was used. When you transferred these patches 
> to the kvm.git-2.6.26-branch, git used the next From-line as the original one 
> was already removed.
>
> While it is not a typical case, is there a better way of specifying multiple 
> authors to avoid future confusion?

It's probably due to my heavy use of git cherry-pick, rebase, and rebase 
-i.  I couldn't reproduce this with a test that mimics that workflow, so 
either it has been fixed already, or it's a little more subtle.

I don't think you should change anything to avoid this.  I'll keep an 
eye open for this, and if it happens again I'll fix it locally and send 
a proper bug report to the git mailing list.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

