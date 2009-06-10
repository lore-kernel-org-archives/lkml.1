Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbZFJWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbZFJWk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZFJWkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:40:51 -0400
Received: from claw.goop.org ([74.207.240.146]:43609 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbZFJWku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:40:50 -0400
Message-ID: <4A303672.8060309@goop.org>
Date: Wed, 10 Jun 2009 15:40:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [GIT PULL] x86/xen changes for v2.6.31
References: <20090610215423.GA31788@elte.hu> <20090610150314.c1593e6e.akpm@linux-foundation.org>
In-Reply-To: <20090610150314.c1593e6e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/09 15:03, Andrew Morton wrote:
> On Wed, 10 Jun 2009 23:54:23 +0200
> Ingo Molnar<mingo@elte.hu>  wrote:
>
>    
>> Linus,
>>
>> Please pull the latest x86-xen-for-linus git tree from:
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-xen-for-linus
>>
>> ...
>>
>> Jeremy Fitzhardinge (32):
>>        mm: disable preemption in apply_to_pte_range
>> ...
>>        mm: allow preemption in apply_to_pte_range
>>      
>
> I think these cancel each other out, don't they?
>    

[ Resent for lkml; Fedora 11's Thunderbird quietly sends HTML by default 
(thanks for that) ]

Yes.  The first is the bare-minimum hacky bugfix, followed by the proper 
fix which reverts the hack.  Just a bit of wankery, basically.

     J
