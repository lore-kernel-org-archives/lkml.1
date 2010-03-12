Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0CLJeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:34:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350Ab0CLJeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:34:15 -0500
Message-ID: <4B9A0A66.2000108@redhat.com>
Date: Fri, 12 Mar 2010 11:33:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ying.huang@intel.com, akpm@linux-foundation.org,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
References: <4B99FD4D.4090206@redhat.com>	<20100312.004202.27822414.davem@davemloft.net>	<4B99FF0A.1030700@redhat.com> <20100312.005051.09912332.davem@davemloft.net>
In-Reply-To: <20100312.005051.09912332.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 10:50 AM, David Miller wrote:
> From: Avi Kivity<avi@redhat.com>
> Date: Fri, 12 Mar 2010 10:44:58 +0200
>
>    
>> Strange, that people can install a new kernel, but not a new
>> assembler.
>>      
> Someone shouldn't have to upgrade their tools to build the
> kernel.
>    

The kernel would still build, just without the AES-NI CTR optimization 
(or kvm).

> And we work very hard to make sure this is the case except
> in the most unavoidable situations.
>    

Why so hard?  It has a cost.  The user can certainly 'make 
AS=~/new-binutils/bin/gas' and it wouldn't even affect the rest of their 
system.

tools/as/ anyone?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

