Return-Path: <linux-kernel-owner+w=401wt.eu-S935255AbXGMPIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255AbXGMPIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbXGMPIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:08:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:47995 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760320AbXGMPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VD1jpu0GLBYpq5UxS+sQITA7shvUBIOswBMPJJsfVO3aldF0OZY0i8Rk1VLOCLjlAWcFEQAem6djCbj05+PfnpwHDDhUP9hZEYJChsW1umSuGJ9q1gHCmWs5LkilGr6xtQRoNBSYPkd5wPePHIfF2OK4XJn9eFEJAEhQ3x+ndrg=
Date: Fri, 13 Jul 2007 23:11:06 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
Message-ID: <20070713151106.GB4023@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070712150135.GA4102@localhost.localdomain> <1184256718.32199.111.camel@weaponx.rchland.ibm.com> <20070713034822.GA2370@localhost.localdomain> <1184320602.2785.18.camel@shinybook.infradead.org> <20070713131458.GA1997@localhost.localdomain> <1184333884.8809.5.camel@hades.cambridge.redhat.com> <20070713142442.GA8190@linux-mips.org> <1184337089.8809.11.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184337089.8809.11.camel@hades.cambridge.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 03:31:29PM +0100, David Woodhouse wrote:
>On Fri, 2007-07-13 at 15:24 +0100, Ralf Baechle wrote:
>> +config MTD_PMC_MSP_EVM
>> +       tristate "CFI Flash device mapped on PMC-Sierra MSP"
>> +       depends on PMC_MSP && MTD_CFI
>> +       select MTD_PARTITIONS
>> 
>> drivers/mtd/maps/Makefile:obj-$(CONFIG_MTD_PMC_MSP_EVM)   +=
>> pmcmsp-flash.o
>> 
>> Is he trying to build something else than very recent kernel.org
>> tree? 
>
>Hm. His mail did say "Even when I use `make allyesconfig`, I still can't
>compile some drivers. I should add the corresponding CONFIGs manually."
>          
>I wonder if he disabled the correct conditions and then tried building
>it in an i386 kernel?
>

Er, I first used 'make allyesconfig', then added CONFIG_MTD_PMC_MSP_EVM=y
manually. And yes, I am on i386.

-- 

If loving computers is wrong, I don't want to be right.
