Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZGBOKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZGBOKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGBOKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:10:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:54984 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGBOKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:10:23 -0400
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Netdev <netdev@vger.kernel.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Message-Id: <70F1C213-8E4B-416D-9414-0D46710FAE32@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1246454380.3681.1634.camel@macbook.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] Support DMA-API debugging facility on PowerPC
Date: Thu, 2 Jul 2009 09:09:41 -0500
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227286492.4901.208.camel@macbook.infradead.org> <20081121165722.GD1386@amd.com> <1227287215.4901.213.camel@macbook.infradead.org> <20081121171802.GK733@elte.hu> <20081121172046.GF1386@amd.com> <1227288269.4901.222.camel@macbook.infradead.org> <20081121172722.GG1386@amd.com> <1233873842.8135.6.camel@macbook.infradead.org> <1246454380.3681.1634.camel@macbook.infradead.org>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 1, 2009, at 8:19 AM, David Woodhouse wrote:

>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Tested-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Some fixing from Johannes to make it apply to a current kernel...
>
> arch/powerpc/Kconfig                   |    1
> arch/powerpc/include/asm/dma-mapping.h |   47 +++++++++++++++++++++++ 
> +++++++---
> arch/powerpc/kernel/dma.c              |   11 +++++++
> 3 files changed, 55 insertions(+), 4 deletions(-)

How about CC'ng linuxppc-dev ;)

I'm not sure if Ben will take this for .31 at this point (with Linus's  
post -rc merge constraints) and if so we will probably move to <asm- 
generic/dma-mapping-common.h> for .32

- k
