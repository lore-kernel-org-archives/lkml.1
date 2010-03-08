Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0CHOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0CHOM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:12:56 -0500
Message-ID: <4B9505E6.1040501@redhat.com>
Date: Mon, 08 Mar 2010 16:12:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/20] KVM: x86 emulator: fix memory access during x86
 emulation
References: <1266414330-27444-1-git-send-email-avi@redhat.com> <1266414330-27444-14-git-send-email-avi@redhat.com> <4B925E66.5@canonical.com> <4B937AF5.5020004@redhat.com> <4B950542.2030306@canonical.com>
In-Reply-To: <4B950542.2030306@canonical.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 04:10 PM, Stefan Bader wrote:
> Avi Kivity wrote:
>    
>> On 03/06/2010 03:53 PM, Stefan Bader wrote:
>>      
>>> i Avi,
>>>
>>> we currently try to integrate this patch for an update into a 2.6.32
>>> based
>>> system (amongst other kvm updates). But as soon as this patch gets
>>> added kvm
>>> will die on startup in kvm_leave_lazy_mmu. This has been documented here:
>>>
>>> https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/531823
>>>
>>> I have placed the backports of your patches, which are currently in
>>> linux-next
>>> and marked for stable here:
>>>
>>> git://kernel.ubuntu.com/smb/linux-2.6.32.y kvm
>>>
>>> I have tested the failure with a version that got only the following
>>> patches in:
>>> KVM: x86 emulator: Add Virtual-8086 mode of emulation
>>> KVM: x86 emulator: fix memory access during x86 emulation
>>> KVM: x86 emulator: Check IOPL level during io instruction emulation
>>> KVM: x86 emulator: Fix popf emulation
>>> KVM: x86 emulator: Check CPL level during privilege instruction emulation
>>>
>>> and also with a version that takes all stable patches up to the bad one:
>>> KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
>>> KVM: x86 emulator: Add group8 instruction decoding
>>> KVM: x86 emulator: Add group9 instruction decoding
>>> KVM: x86 emulator: Add Virtual-8086 mode of emulation
>>> KVM: x86 emulator: fix memory access during x86 emulation
>>>
>>> But as soon as the fix for memory access gets added, the bug will
>>> occur. Would
>>> you have an idea what might be causing this?
>>>
>>>        
>> Does the same guest, using the same qemu-kvm, work on kvm.git or upstream?
>>
>>      
> The test was done with a kvm user-space package based on 0.12.3 (which seems to
> be the current upstream version). I try to do a test on the git version.
>    

I meant keep the same userspace without change, and try it on a Linus 
kernel or kvm.git master 
(http://git.kernel.org/?p=virt/kvm/kvm.git;a=summary).

-- 
error compiling committee.c: too many arguments to function

