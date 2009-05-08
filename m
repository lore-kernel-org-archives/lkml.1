Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbZEHIUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbZEHIUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZEHITw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:19:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbZEHITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:19:51 -0400
Message-ID: <4A03EB00.2070203@redhat.com>
Date: Fri, 08 May 2009 11:19:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <alpine.DEB.1.10.0905072012460.31280@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905072012460.31280@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Thu, 7 May 2009, Avi Kivity wrote:
>
>   
>> What's your take on adding irq context safe callbacks to irqfd?
>>
>> To give some background here, we would like to use eventfd as a generic
>> connector between components, so the components do not know about each other.
>> So far eventfd successfully abstracts among components in the same process, in
>> different processes, and in the kernel.
>>
>> eventfd_signal() can be safely called from irq context, and will wake up a
>> waiting task.  But in some cases, if the consumer is in the kernel, it may be
>> able to consume the event from irq context, saving a context switch.
>>
>> So, will you consider patches adding this capability to eventfd?
>>     
>
> Since I received this one after your ACK on the capability of eventfd of 
> triggering callbacks, I assume we're clear on this point, aren't we?
>   

We are.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

