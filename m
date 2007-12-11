Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXLKNqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXLKNqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKNqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:46:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:38364 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXLKNqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:46:37 -0500
Message-ID: <475E94BA.8060402@qumranet.com>
Date: Tue, 11 Dec 2007 15:46:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
References: <475E5CBB.9080608@qumranet.com> <200712111438.51142.borntraeger@de.ibm.com>
In-Reply-To: <200712111438.51142.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Dienstag, 11. Dezember 2007 schrieb Avi Kivity:
>   
>> KVM is due to receive support for multiple architectures (ppc, ia64, and 
>> s390, in addition to the existing x86), hopefully in time for the 2.6.25 
>> merge window.  It is awkward to place the new arch support in 
>> drivers/kvm/, so I'd like to propose the following new layout:
>>
>>   virt/         top-level directory for hypervisors
>>   virt/kvm/     kvm common code
>>   virt/lguest/  the other hypervisor
>>   arch/*/kvm/   arch dependent kvm code
>>   include/linux/kvm.h       arch independent interface
>>   include/asm/kvm.h         arch dependent interface
>>   include/linux/kvm_para.h  arch independent guest interface
>>   include/asm/kvm_para.h    arch dependent guest interface
>>
>> The include/ hierarchy is already in place; I'm including it for 
>> completeness.
>>     
>
> For completeness, where do we want to put the drivers?
> drivers/*, drivers/net/* etc. 
> or
> drivers/kvm/* drivers/xen/* etc.
>   

There's already drivers/virtio/ for kvm.  If kvm-specific drivers come 
up, we can place them in drivers/kvm/.

-- 
error compiling committee.c: too many arguments to function

