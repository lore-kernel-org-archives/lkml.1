Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZEERoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZEERoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZEERoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:44:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbZEERoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:44:21 -0400
Message-ID: <4A007AD1.2020309@redhat.com>
Date: Tue, 05 May 2009 20:43:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A005F05.30409@redhat.com> <4A0078B5.7030509@novell.com>
In-Reply-To: <4A0078B5.7030509@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>  
>>> +struct kvm_irqfd {
>>> +    __u32 gsi;
>>> +    __u32 flags;
>>> +};
>>> +
>>>   
>>>       
>> Please add some reserved space here.
>>     
>
> Ack.  Any rule of thumb here?  How about a "__u8 pad[16]" ?
>   

I'd round it up so the whole thing is 32 bytes (not that it matters).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

