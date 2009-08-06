Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZHFMtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZHFMtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZHFMtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:49:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZHFMtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:49:33 -0400
Message-ID: <4A7AD29E.50800@redhat.com>
Date: Thu, 06 Aug 2009 15:54:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       alacrityvm-devel@lists.sourceforge.net, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com> <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com>
In-Reply-To: <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 03:08 PM, Gregory Haskins wrote:
>> Merging the guest first means relying on
>> kernel interface from an out of tree driver, which well might change
>> before it goes in.
>>      
>
> ABI compatibility is already addressed/handled, so even if that is true its not a problem.
>
>    

Really the correct way to address the ABI is to publish a spec and write 
both host and guest drivers to that.  Unfortunately we didn't do this 
with virtio.

It becomes more important when you have multiple implementations (e.g. 
Windows drivers).

>>> This series implements the guest-side drivers for accelerated IO
>>> when running on top of the AlacrityVM hypervisor, the details of
>>> which you can find here:
>>>
>>> http://developer.novell.com/wiki/index.php/AlacrityVM
>>>        
>> Since AlacrityVM is kvm based, Cc kvm@vger.kernel.org.
>>      
>
> I *can* do that, but there is nothing in these drivers that is KVM specific (its all pure PCI and VBUS).  I've already made the general announcement about the project/ml cross posted to KVM for anyone that might be interested, but I figure I will spare the general KVM list the details unless something specifically pertains to, or affects, KVM.  For instance, when I get to pushing the hypervisor side, I still need to work on getting that 'xinterface' patch to you guys.  I would certainly be CC'ing kvm@vger when that happens since it modifies the KVM code.
>
> So instead, I would just encourage anyone interested (such as yourself) to join the alacrity list so I don't bother the KVM community unless absolutely necessary.
>    

It's true that vbus is a separate project (in fact even virtio is 
completely separate from kvm).  Still I think it would be of interest to 
many kvm@ readers.


-- 
error compiling committee.c: too many arguments to function

