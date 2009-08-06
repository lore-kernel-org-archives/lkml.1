Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZHFNDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZHFNDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZHFNDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:03:42 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:24446 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZHFNDl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;3:2>);
	Thu, 6 Aug 2009 09:03:41 -0400
Message-Id: <4A7A9C6B0200005A00051BB9@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 Beta 
Date: Thu, 06 Aug 2009 07:03:39 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Avi Kivity" <avi@redhat.com>
Cc: <alacrityvm-devel@lists.sourceforge.net>,
       "Michael S. Tsirkin" <mst@redhat.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net>
 <20090806081955.GA9752@redhat.com>
 <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com>
 <4A7AD29E.50800@redhat.com>
In-Reply-To: <4A7AD29E.50800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 8/6/2009 at  8:54 AM, in message <4A7AD29E.50800@redhat.com>, Avi Kivity
<avi@redhat.com> wrote: 
> On 08/06/2009 03:08 PM, Gregory Haskins wrote:
>>> Merging the guest first means relying on
>>> kernel interface from an out of tree driver, which well might change
>>> before it goes in.
>>>      
>>
>> ABI compatibility is already addressed/handled, so even if that is true its 
> not a problem.
>>
>>    
> 
> Really the correct way to address the ABI is to publish a spec and write 
> both host and guest drivers to that.  Unfortunately we didn't do this 
> with virtio.
> 
> It becomes more important when you have multiple implementations (e.g. 
> Windows drivers).
> 
>>>> This series implements the guest-side drivers for accelerated IO
>>>> when running on top of the AlacrityVM hypervisor, the details of
>>>> which you can find here:
>>>>
>>>> http://developer.novell.com/wiki/index.php/AlacrityVM
>>>>        
>>> Since AlacrityVM is kvm based, Cc kvm@vger.kernel.org.
>>>      
>>
>> I *can* do that, but there is nothing in these drivers that is KVM specific 
> (its all pure PCI and VBUS).  I've already made the general announcement 
> about the project/ml cross posted to KVM for anyone that might be interested, 
> but I figure I will spare the general KVM list the details unless something 
> specifically pertains to, or affects, KVM.  For instance, when I get to 
> pushing the hypervisor side, I still need to work on getting that 
> 'xinterface' patch to you guys.  I would certainly be CC'ing kvm@vger when 
> that happens since it modifies the KVM code.
>>
>> So instead, I would just encourage anyone interested (such as yourself) to 
> join the alacrity list so I don't bother the KVM community unless absolutely 
> necessary.
>>    
> 
> It's true that vbus is a separate project (in fact even virtio is 
> completely separate from kvm).  Still I think it would be of interest to 
> many kvm@ readers.

Well, my goal was to not annoy KVM readers. ;)  So if you feel as though there is benefit to having all of KVM CC'd and I won't be annoying everyone, I see no problem in cross posting.

Would you like to see all conversations, or just ones related to code (and, of course, KVM relevant items)?

Regards,
-Greg



