Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbXGMNMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbXGMNMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXGMNM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:12:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:47043 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbXGMNMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YCAG58N59e9Zu3gQkdVFy0MLvjSkwnGC7Dhne5vxb0J2e/BO32ekpPWZD8ayGCk30nUxSD3cYkPfyDtVmd8dS7xdzlU5zuddES1tlR+UzwejvLM51kPpOo2JqYw2+03YrybRxs75Hfh5zYpvv0q8nZpJZDrOw1CQYdo5lROuQpg=
Date: Fri, 13 Jul 2007 21:14:58 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
Message-ID: <20070713131458.GA1997@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070712150135.GA4102@localhost.localdomain> <1184256718.32199.111.camel@weaponx.rchland.ibm.com> <20070713034822.GA2370@localhost.localdomain> <1184320602.2785.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184320602.2785.18.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 10:56:42AM +0100, David Woodhouse wrote:
>On Fri, 2007-07-13 at 11:48 +0800, WANG Cong wrote:
>>                 if(map_banks[idx] == NULL) {
>>                         ret = -ENOMEM;
>> -                       /* FIXME: What if some MTD devices were probed already? */
>> +                       /* FIXME: What if some MTD devices were probed
>> +                       already? */
>>                         goto error_mem;
>>                 } 
>
>
>That's just horrid. Leave it as it was.
>

Sorry, I can't fully understand you. You mean only the above change is horrid or
the entire patch?

I have some questions about mtd/maps drivers. Even when I use `make allyesconfig`,
I still can't compile some drivers. I should add the corresponding CONFIGs manually.
Why this? And I still got some errors and warnings, such as:

drivers/mtd/maps/pmcmsp-flash.c:40:22: error: msp_prom.h: No such file or directory
drivers/mtd/maps/pmcmsp-flash.c:41:22: error: msp_regs.h: No such file or directory
drivers/mtd/maps/pmcmsp-flash.c: In function 'init_msp_flash':
drivers/mtd/maps/pmcmsp-flash.c:62: error: 'DEV_ID_REG' undeclared (first use in this function)
drivers/mtd/maps/pmcmsp-flash.c:62: error: (Each undeclared identifier is reported only once
drivers/mtd/maps/pmcmsp-flash.c:62: error: for each function it appears in.)
drivers/mtd/maps/pmcmsp-flash.c:62: error: 'DEV_ID_SINGLE_PC' undeclared (first use in this function)
drivers/mtd/maps/pmcmsp-flash.c:63: error: 'ELB_1PC_EN_REG' undeclared (first use in this function)
drivers/mtd/maps/pmcmsp-flash.c:63: error: 'SINGLE_PCCARD' undeclared (first use in this function)

Did I miss something?


Thanks!

-- 

If loving computers is wrong, I don't want to be right.
