Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXJ3Kg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXJ3Kg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXJ3Kgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:36:50 -0400
Received: from kassel160.server4you.de ([62.75.246.160]:57305 "EHLO csgraf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXJ3Kgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:36:49 -0400
X-Greylist: delayed 2042 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 06:36:49 EDT
In-Reply-To: <4726FE2A.1040607@siemens.com>
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>	<4726B088.1010709@qumranet.com> <4726DF66.4000000@osadl.org> <4726FE2A.1040607@siemens.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <ED9A6D69-650B-47D3-A305-91D947925F5F@csgraf.de>
Cc: kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carsten Emde <Carsten.Emde@osadl.org>
Content-Transfer-Encoding: 7bit
From: Alexander Graf <alex@csgraf.de>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
Date: Tue, 30 Oct 2007 11:02:43 +0100
To: Jan Kiszka <jan.kiszka@siemens.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30, 2007, at 10:49 AM, Jan Kiszka wrote:

> Carsten Emde wrote:
>> Avi Kivity wrote:
>>> David Brown wrote:
>>>> I thought I'd try out the realtime patch set and it didn't work  
>>>> at all
>>>> with kvm. The console didn't dump anything and the system  
>>>> completely
>>>> locked up.
>> Up to now, the unmodified kvm module never worked with any RT kernel.
>> This would only change, if RT patched kernels were routinely used  
>> in the
>> kvm release tests which is, for the time being, not the case.
>
> As far as I understood (but didn't re-test yet), latest kvm release  
> does
> include all features required to run over -rt. This was at least the
> case for kvm-git I picked up last week and merged into 2.6.23-rt1. The
> only issue is that out-of-tree kvm doesn't enable the preemption
> notifiers (maybe there were one or two further minor issues, I  
> think to
> recall missing smp_ops exports being one, but these were not -rt  
> related).
>
>>
>> However, tglx once provided a hand-crafted kvm version that can be  
>> used
>> together with a selected RT kernel -> see "Latest Stable"
>> (http://www.osadl.org/Latest-Stable.latest-stable-realtime-kernel. 
>> 0.html)
>> realtime kernel. It is based on kernel 2.6.21.6-rt21 and kvm-28.
>>
>> We used these modules to carry out a number of "proof of concept"  
>> tests
>> which were very successful. The realtime capabilities of the host  
>> system
>> remained unchanged irrespective of whether the kvm guest system (no
>> graphics) was running or not. This was even the case while the guest
>> system was booting.
>
> Interesting result - you've read about the wbinvd issues? Is there no
> wbinvd in the bios shipped with older kvm? Which VM extension did you
> test, both Intel and AMD? I would bet that your X issues are due to  
> the
> same effect. X startup/shutdown involves a lot of wbinvd calls on my
> test boxes.
>
> To sum up my findings: kvm over whatever RT kernel is risky
> (latency-wise) unless you can audit or even para-virtualise your guest
> OS /wrt wbinvd. Maybe we can discuss this also in Linz by the end  
> of the
> week. :)

As I will be in Linz by the end of the week as well, could you please  
try to do any coordination as to when you meet on the lists (or CC  
me)? I'd like to get the chance to join you on this :-).

Thanks,

Alex
