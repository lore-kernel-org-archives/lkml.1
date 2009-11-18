Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZKRJjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZKRJjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZKRJjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:39:00 -0500
Received: from mail45.e.nsc.no ([193.213.115.45]:34112 "EHLO mail45.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZKRJi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:38:59 -0500
Message-ID: <4B03C0B4.6080300@free.fr>
Date: Wed, 18 Nov 2009 10:39:00 +0100
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
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

Hello,
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
Thanks for the reply.

I will try to bissect the problem (I have to start from the first rc1 
and go backward from that) but it might take some time since I am not an 
expert in git. What I can say is that the problem occur since the first 
rc of the kernel (and whatever recent version of libdrm). Moreover, I 
have this after a cold boot. Another person reported the same problem on 
the xorg list, so I am not alone :-).

regards

Mathieu

