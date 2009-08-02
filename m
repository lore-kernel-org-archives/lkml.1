Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZHBPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZHBPoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZHBPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 11:44:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZHBPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 11:44:52 -0400
Message-ID: <4A75B56D.5070407@redhat.com>
Date: Sun, 02 Aug 2009 18:49:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Problems with CONFIG_KVM_GUEST?
References: <20090801212616.GD734@mit.edu> <4A755EB3.9080502@redhat.com> <20090802153238.GC15828@mit.edu>
In-Reply-To: <20090802153238.GC15828@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2009 06:32 PM, Theodore Tso wrote:
> On Sun, Aug 02, 2009 at 12:38:59PM +0300, Avi Kivity wrote:
>    
>> (Adding ccs)
>>
>> On 08/02/2009 12:26 AM, Theodore Tso wrote:
>>      
>>> Using the XFS QA regression test suites to test ext4, I reliably get
>>> lock-ups and OOPS's with I run a kernel using KVM with
>>> CONFIG_KVM_GUEST configured.  This is with 2.6.31-rc3 and 2.6.31-rc4.
>>>
>>> The problems disappear if I turn off CONFIG_KVM_GUEST; the XFS tests
>>> run without problem to completion once I turn this configuration
>>> option off.  That's what I'll do for now, but if someone could look
>>> into this, I'd appreciate it.
>>>
>>>        
>> Is this a PAE mode guest?
>>      
>
> Yes, it is.  Here's the config (with CONFIG_KVM_GUEST turned off, but
> otherwise what I had testing with).
>
>    

What's the host kernel version?

We had problems with CONFIG_KVM_GUEST and PAE which were resolved in 
2.6.30-final but perhaps failed to trickle down to whatever you're 
using.  The upstream commit is a8cd0244 ("KVM: Make paravirt tlb flush 
also reload the PAE PDPTRs").

-- 
error compiling committee.c: too many arguments to function

