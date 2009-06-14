Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZFNLxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZFNLxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZFNLx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:53:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZFNLxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:53:25 -0400
Message-ID: <4A34E4A5.3040306@redhat.com>
Date: Sun, 14 Jun 2009 14:53:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com> <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain> <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 13 Jun 2009, Linus Torvalds wrote:
>   
>> On Sat, 13 Jun 2009, Paul Mackerras wrote:
>>     
>>> Linus, Andrew: OK if this goes in via the powerpc tree?
>>>       
>> Ok by me.
>>     
>
> Btw, do 32-bit architectures really necessarily want 64-bit performance 
> counters? 
>
> I realize that 32-bit counters will overflow pretty easily, but I do 
> wonder about the performance impact of doing things like hashed spinlocks 
> for 64-bit counters. Maybe the downsides of 64-bit perf counters on such 
> architectures might outweight the upsides?
>   

An alternative implementation using 64-bit cmpxchg will recover most of 
the costs of hashed spinlocks.  I assume most serious 32-bit 
architectures have them?

-- 
error compiling committee.c: too many arguments to function

