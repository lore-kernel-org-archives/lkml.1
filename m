Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXJZJpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXJZJpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762069AbXJZJoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:44:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:50663 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbXJZJoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:44:11 -0400
In-Reply-To: <d12d72446eb0ff40da5e709b1f658df479b92658.1193390975.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org> <d12d72446eb0ff40da5e709b1f658df479b92658.1193390975.git.jeff@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CF660BA8-BEC6-4CB7-9627-0135ACD46DD8@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davem@davemloft.net, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] IA64, PPC, SPARC: minor irq handler cleanups
Date: Fri, 26 Oct 2007 04:44:26 -0500
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26, 2007, at 4:40 AM, Jeff Garzik wrote:

> ia64/sn/kernel/huberror.c:
> 	- remove pointless void* cast
> 	- add KERN_xxx prefix
>
> ia64/sn/pci/tioce_provider.c: start functions at column zero
>
> ppc/8xx_io/fec.c: kill prototype, remove extra whitespace
>
> ppc/platforms/85xx/*
> 	'irq' argument in irq handler is used purely as a temporary
> 	variable.  Update the function to reflect this usage, changing
> 	the first arg's name from 'irq' to 'dummy'
>
> ppc/platforms/sbc82xx.c: ditto
>
> sparc/kernel/time.c: mark timer_interrupt() static (from DaveM)
>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  arch/ia64/sn/kernel/huberror.c               |    4 ++--
>  arch/ia64/sn/pci/tioce_provider.c            |    6 ++++--
>  arch/ppc/8xx_io/fec.c                        |    3 +--
>  arch/ppc/platforms/85xx/mpc8560_ads.c        |    4 +++-
>  arch/ppc/platforms/85xx/mpc85xx_cds_common.c |    4 +++-
>  arch/ppc/platforms/85xx/stx_gp3.c            |    4 +++-
>  arch/ppc/platforms/85xx/tqm85xx.c            |    4 +++-
>  arch/ppc/platforms/sbc82xx.c                 |    4 +++-
>  arch/sparc/kernel/time.c                     |    2 +-
>  9 files changed, 23 insertions(+), 12 deletions(-)

I haven't been following this with detail.  Is the intent that this  
would be for 2.6.24 or .25?

- k
