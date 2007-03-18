Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbXCRKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbXCRKcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXCRKcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:32:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:56000 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbXCRKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:32:16 -0400
Message-ID: <45FD152E.6020207@qumranet.com>
Date: Sun, 18 Mar 2007 12:32:14 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FCCC39.7090104@qumranet.com> <20070318102252.GA11201@osiris.ibm.com>
In-Reply-To: <20070318102252.GA11201@osiris.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, Mar 18, 2007 at 07:20:57AM +0200, Avi Kivity wrote:
>   
>> Heiko Carstens wrote:
>>     
>>> On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
>>>  
>>>       
>>>> This patchset updates the kvm userspace interface to what I hope will
>>>> be the long-term stable interface.  Provisions are included for extending
>>>> the interface later.  The patches address performance and cleanliness
>>>> concerns.
>>>>         
>>> [...]
>>> But the general question is: do you still plan to switch to a syscall
>>> interface?
>>>       
>> I don't have any present plans for that.  Maybe when the interface starts
>> to evolve at a slower pace, or if it is shown to be significantly faster.
>>
>> Not that interface stabilization here doesn't mean a freeze; it means that
>> backwards compatibility starts when this gets merged.
>>     
>
> If the interface is considered to be stable you can get rid of the
> KVM_GET_API_VERSION ioctl, since the version can't change anymore, right?
>   

It's needed in case pre-stabilization userspace tries to use the 
stabilized interface.  It's true the version won't change.

But maybe we can get rid of it, and the old userspace will just fail on 
the ioctl (we need to keep it reserved for that).

-- 
error compiling committee.c: too many arguments to function

