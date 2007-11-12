Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXKLQW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXKLQW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXKLQWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:22:52 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:51205 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbXKLQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:22:51 -0500
Message-ID: <47387DC7.9090001@checkpoint.com>
Date: Mon, 12 Nov 2007 18:22:31 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Adrian Bunk <bunk@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com> <47387214.2010200@checkpoint.com> <20071112153908.GK9771@stusta.de> <47387810.3060503@checkpoint.com> <20071112161106.GB24243@fattire.cabal.ca>
In-Reply-To: <20071112161106.GB24243@fattire.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I see. Thanks, guys.


-------- Original Message  --------

Subject: Re: PAGE_SIZE on 64bit and 32bit machines
From: Kyle McMartin <kyle@mcmartin.ca>
To: Yoav Artzi <yoavar@checkpoint.com>
Date: Monday, November 12, 2007 6:11:06 PM

> On Mon, Nov 12, 2007 at 05:58:08PM +0200, Yoav Artzi wrote:
>   
>> Looking at the source, I see:
>>
>> #ifdef CONFIG_4KSTACKS
>> #define THREAD_SIZE            (4096)
>> #else
>> #define THREAD_SIZE        (8192)
>> #endif
>>
>>
>> So if I configure the option CONFIG_4KSTACK, I will get a 4KB kernel 
>> stack. Am I missing something here?
>>
>>     
>
> This is only on i386 (32-bit x86...)[1] On x86-64, we have 8K kernel
> stacks (THREAD_ORDER 1), and 16K irqstacks (IRQSTACK_ORDER 2).
>
> The relevant defines are found in <asm-x86/page_64.h> for x86_64, and
> <asm-x86/thread_info_32.h> for i386.
>
> Cheers,
> 	Kyle
>
> 1. That is, stack size is only configurable on 32bit.
>
> Scanned by Check Point VPN-1 UTM NGX R65 with Messaging Security
>
>   

