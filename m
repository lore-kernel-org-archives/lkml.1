Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXJZJt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXJZJt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbXJZJtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:49:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50582 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbXJZJtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:49:16 -0400
Message-ID: <4721B817.7090602@garzik.org>
Date: Fri, 26 Oct 2007 05:49:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davem@davemloft.net, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org
Subject: Re: [PATCH] IA64, PPC, SPARC: minor irq handler cleanups
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org> <d12d72446eb0ff40da5e709b1f658df479b92658.1193390975.git.jeff@garzik.org> <CF660BA8-BEC6-4CB7-9627-0135ACD46DD8@kernel.crashing.org>
In-Reply-To: <CF660BA8-BEC6-4CB7-9627-0135ACD46DD8@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Oct 26, 2007, at 4:40 AM, Jeff Garzik wrote:
> 
>> ia64/sn/kernel/huberror.c:
>>     - remove pointless void* cast
>>     - add KERN_xxx prefix
>>
>> ia64/sn/pci/tioce_provider.c: start functions at column zero
>>
>> ppc/8xx_io/fec.c: kill prototype, remove extra whitespace
>>
>> ppc/platforms/85xx/*
>>     'irq' argument in irq handler is used purely as a temporary
>>     variable.  Update the function to reflect this usage, changing
>>     the first arg's name from 'irq' to 'dummy'
>>
>> ppc/platforms/sbc82xx.c: ditto
>>
>> sparc/kernel/time.c: mark timer_interrupt() static (from DaveM)
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>>  arch/ia64/sn/kernel/huberror.c               |    4 ++--
>>  arch/ia64/sn/pci/tioce_provider.c            |    6 ++++--
>>  arch/ppc/8xx_io/fec.c                        |    3 +--
>>  arch/ppc/platforms/85xx/mpc8560_ads.c        |    4 +++-
>>  arch/ppc/platforms/85xx/mpc85xx_cds_common.c |    4 +++-
>>  arch/ppc/platforms/85xx/stx_gp3.c            |    4 +++-
>>  arch/ppc/platforms/85xx/tqm85xx.c            |    4 +++-
>>  arch/ppc/platforms/sbc82xx.c                 |    4 +++-
>>  arch/sparc/kernel/time.c                     |    2 +-
>>  9 files changed, 23 insertions(+), 12 deletions(-)
> 
> I haven't been following this with detail.  Is the intent that this 
> would be for 2.6.24 or .25?

These patches are all cleanups and minor fixes I found while iterating 
through each interrupt handler in the kernel, in pursuit of a related 
project.

So they can stand by themselves, and can integrate into whatever flow 
maintainers find most comfortable.

I'm not in any rush, but neither would I like them to sit forever...

	Jeff


