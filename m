Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbZG0L2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbZG0L2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZG0L2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:28:47 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:37501 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbZG0L2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:28:47 -0400
Message-ID: <4A6D8F68.1030202@blueyonder.co.uk>
Date: Mon, 27 Jul 2009 12:28:40 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-1.1 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OpenSolaris boot failure with KVM and VirtualBox
References: <4A5ED714.7010304@blueyonder.co.uk> <4A6C80C3.8090007@redhat.com> <4A6C9D1F.3090404@blueyonder.co.uk> <4A6C9DE6.8080002@redhat.com> <4A6CD1AD.6090009@blueyonder.co.uk> <8CF02BC9-C112-422B-A9D7-9B391F6EA694@suse.de> <4A6D8B66.9030909@blueyonder.co.uk> <8A7B7BFF-9561-478A-898F-DD7031558960@suse.de>
In-Reply-To: <8A7B7BFF-9561-478A-898F-DD7031558960@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/09 12:17, Alexander Graf wrote:
> 
> On 27.07.2009, at 13:11, Sid Boyce wrote:
> 
>> On 27/07/09 06:36, Alexander Graf wrote:
>>>
>>> On 26.07.2009, at 23:59, Sid Boyce wrote:
>>>
>>>> On 26/07/09 19:18, Avi Kivity wrote:
>>>>> On 07/26/2009 09:14 PM, Sid Boyce wrote:
>>>>>>
>>>>>>> Is this a regression from previous kernel versions?  What userspace
>>>>>>> are
>>>>>>> you using?
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Currently running 2.6.31-rc4 with the original kqemu-1.4.0pre1 on
>>>>>> openSUSE 11.2 Milestone 4 and it boots OK - a 200G disk image used.
>>>>>> qemu-system-x86_64 -cdrom /ISO/osol-0906-ai-x86.iso -boot d
>>>>>> /osol0906.qcow2 -smp 4 -m 500M&
>>>>>>
>>>>>
>>>>> Wait, are you using kqemu or kvm?
>>>>>
>>>>
>>>> # l /dev/kvm
>>>> crw-rw----+ 1 root root 10, 232 2009-07-24 20:26 /dev/kvm
>>>> # lsmod|grep kvm
>>>> kvm_amd                41908  0
>>>> kvm                   180488  1 kvm_amd
>>>>
>>>> From long ago I read that kvm needed kqemu, so I have always built the
>>>> module, but I see here it's not used.
>>>> lsmod|grep qemu
>>>> kqemu                 173496  0
>>>>
>>>> # rpm -qf /usr/bin/qemu-system-x86_64
>>>> qemu-0.10.1-2.21
>>>
>>> You're not using KVM. "Qemu" is the non-KVM version.
>>>
>>> Maybe uli activated the preliminary kvm support in there, but if you
>>> want the real deal, install the "kvm" package and use /usr/bin/qemu-kvm.
>>>
>>> Alex
>>>
>>>
>>>
>>
>> Thanks, I shall check that out, no mention of x86_64, but I shall have a
>> look at the stuff below.
>> From  Documentation/ia64/kvm.txt
>> 1. Get the kvm source from git.kernel.org.
>>        Userspace source:
>>                git clone
>> git://git.kernel.org/pub/scm/virt/kvm/kvm-userspace.git
> 
> (leaving out the MLs since this really doesn't belong there)
> 
> Just do "zypper in kvm" and you should be set.
> 
> Alex
> 
> 
> 
Thanks, I had kvm-kmp-default locked, so that's no doubt why kvm isn't
installed.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

