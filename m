Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZKRMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZKRMyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZKRMyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:54:16 -0500
Received: from mail48.e.nsc.no ([193.213.115.48]:53893 "EHLO mail48.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZKRMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:54:15 -0500
Message-ID: <4B03EE79.1020306@free.fr>
Date: Wed, 18 Nov 2009 13:54:17 +0100
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090707 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] intel KMS bug on i915
References: <4AFAA396.5040903@free.fr> <1258433661.4882.5.camel@gaiman.anholt.net>
In-Reply-To: <1258433661.4882.5.camel@gaiman.anholt.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 05:54 AM, Eric Anholt wrote:
> On Wed, 2009-11-11 at 12:44 +0100, Mathieu Taillefumier wrote:
>    
>> Hello,
>>
>> I recently switched to the last git kernel (the rc6) and have a serious
>> problem with KMS and xorg. I reported it to the xorg list but after some
>> research it seems that this problem is caused by some recent change in
>> the intel KMS stack. Some warnings and errors are reported by the
>> kernel. they are the following (only a small part of it):
>>
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> render error detected, EIR: 0x00000000
>> i915: Waking up sleeping processes
>> [drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting 2
>> at 1)
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> render error detected, EIR: 0x00000000
>>
>> This problem is recurrent with all 2.6.32-rc versions and gives rise to
>> an unusable xorg (independent of the version), while the same xorg stack
>> works pretty well with the 2.6.31 kernel. The hardware is a sony laptop
>> with a intel 965 chipset and the bug can be reproduced at 100%
>>      
> Could you bisect the problem?  I don't think I've seen reports of this
> (fails at a time other than resume)
>    
I finished my first bisect session but I obtain nothing that can be of 
any help so far. I think I just did a mistake somewhere in the process. 
I should point that I obtained some back screen during the process but 
no messages from the kernel nor xorg that I validated as wrong.

I am also wondering if the first drm commit that implement the dynamic 
clock setting is not responsible for it. Is there a way to deactivate it 
from the kernel command line or should i revert the commit to test that ?

best

Mathieu
