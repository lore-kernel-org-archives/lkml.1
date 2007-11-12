Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbXKLP6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbXKLP6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbXKLP6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:58:24 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:45275 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXKLP6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:58:23 -0500
Message-ID: <47387810.3060503@checkpoint.com>
Date: Mon, 12 Nov 2007 17:58:08 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com> <47387214.2010200@checkpoint.com> <20071112153908.GK9771@stusta.de>
In-Reply-To: <20071112153908.GK9771@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the source, I see:

#ifdef CONFIG_4KSTACKS
#define THREAD_SIZE            (4096)
#else
#define THREAD_SIZE        (8192)
#endif


So if I configure the option CONFIG_4KSTACK, I will get a 4KB kernel 
stack. Am I missing something here?


-------- Original Message  --------

Subject: Re: PAGE_SIZE on 64bit and 32bit machines
From: Adrian Bunk <bunk@kernel.org>
To: Yoav Artzi <yoavar@checkpoint.com>
Date: Monday, November 12, 2007 5:39:08 PM

> On Mon, Nov 12, 2007 at 05:32:36PM +0200, Yoav Artzi wrote:
>
>   
>> Well, since the size of the kernel stack is one page,
>> ...
>>     
>
> That's not true.
>
> cu
> Adrian
>
>   

