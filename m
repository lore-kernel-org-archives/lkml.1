Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXGMPC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXGMPC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759652AbXGMPCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:02:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:44388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbXGMPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WzOhiF90mYXFSZwm2pFDguIXgsTlvPmwLq61bT0d+NXEg4572tdTg6AE+CRmpSS/YrWiczw2PTSvxziwkN6+U1uKKyJuGAoWXGRgEdFzt1UJGShLxA7DFCkqWDj8jZE2Lmes0sz8wAS51xHQhtnxzGnlqjzUNAsKnGVc++P7ZuU=
Date: Fri, 13 Jul 2007 23:05:03 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
Message-ID: <20070713150503.GA4023@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070712150135.GA4102@localhost.localdomain> <1184256718.32199.111.camel@weaponx.rchland.ibm.com> <20070713034822.GA2370@localhost.localdomain> <1184320602.2785.18.camel@shinybook.infradead.org> <20070713131458.GA1997@localhost.localdomain> <1184333884.8809.5.camel@hades.cambridge.redhat.com> <20070713142442.GA8190@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713142442.GA8190@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 03:24:43PM +0100, Ralf Baechle wrote:
>On Fri, Jul 13, 2007 at 02:38:03PM +0100, David Woodhouse wrote:
>
>> > drivers/mtd/maps/pmcmsp-flash.c:63: error: 'ELB_1PC_EN_REG' undeclared (first use in this function)
>> > drivers/mtd/maps/pmcmsp-flash.c:63: error: 'SINGLE_PCCARD' undeclared (first use in this function)
>> > 
>> > Did I miss something?
>> 
>> I think that map driver should probably depend on CONFIG_PMC_MSP. Ralf?
>
>*confused*
>
>68aa0fa87f6d4b2f5e8ad39ecaec8bba9137bb3d did add:
>
>+config MTD_PMC_MSP_EVM
>+       tristate "CFI Flash device mapped on PMC-Sierra MSP"
>+       depends on PMC_MSP && MTD_CFI
>+       select MTD_PARTITIONS
>
>drivers/mtd/maps/Makefile:obj-$(CONFIG_MTD_PMC_MSP_EVM)   += pmcmsp-flash.o
>
>Is he trying to build something else than very recent kernel.org tree?
>

Yes. very recent, 2.6.22.1.


-- 

If loving computers is wrong, I don't want to be right.
