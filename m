Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZGGM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZGGM7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZGGM7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:59:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41770 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbZGGM7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:59:01 -0400
Date: Tue, 7 Jul 2009 15:58:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
Message-ID: <20090707125823.GA7578@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A533C4C.7020202@novell.com> <20090707124810.GD3647@redhat.com> <4A5345E9.6050502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5345E9.6050502@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 03:56:09PM +0300, Avi Kivity wrote:
> On 07/07/2009 03:48 PM, Michael S. Tsirkin wrote:
>>>>> +
>>>>> +		__kvm_io_bus_unregister_dev(bus,&p->dev);
>>>>> +		iosignalfd_release(p);
>>>>>
>>>>>          
>>>> a single deassign removed multiple irqfds? Looks ugly.
>>>>
>>>>        
>>> Avi requested this general concept.
>>>      
>>
>> Really? Avi, could you explain? I would think each
>> assign needs to be matched with 1 deassign. No?
>>    
>
> Doesn't it follow naturally?

Yes.

> How can a single deassign remove multiple  
> fds (unless all were registered with exactly the same arguments)?
> Maybe we should instead detect that the duplicate iosignaldfds are  
> registered.
>
> Note that we do need to allow the same fd to be multiple times, but not  
> with exactly the same address/match etc.

-- 
MST
