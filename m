Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbXKLPcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbXKLPcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXKLPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:32:38 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:39561 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXKLPci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:32:38 -0500
Message-ID: <47387214.2010200@checkpoint.com>
Date: Mon, 12 Nov 2007 17:32:36 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com>
In-Reply-To: <47386DC9.4020905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, since the size of the kernel stack is one page, I figured it will 
grow when switching to 64-bit, because some of the types grow and a 
similar flow/stack will be bigger in 64-bit in comparison to 32-bit.

Keeping the page size at 4kb and so keeping the stack at 4kb is a bit 
dangerous. Isn't it?

I know that using one page for a kernel stack is a optional feature, but:

a) It's a good feature

b) It's already used by major distros, e.g. Red Hat



-------- Original Message  --------

Subject: Re: PAGE_SIZE on 64bit and 32bit machines
From: Jiri Slaby <jirislaby@gmail.com>
To: Yoav Artzi <yoavar@checkpoint.com>
Date: Monday, November 12, 2007 5:14:17 PM

> On 11/12/2007 03:39 PM, Yoav Artzi wrote:
>   
>> According to my knowledge the PAGE_SIZE on 32bit architectures in 4KB.
>> Logically, the PAGE_SIZE on 64bit architectures should be 8KB. That's at
>> least the way I understand it. However, looking at the kernel code of
>> x86_64, I see the PAGE_SIZE is 4KB.
>>     
>
> Yes, it stood unchanged, the only difference is 4-level page tables.
>
>   
>> Can anyone explain to me what am I missing here?
>>     
>
> What led you to that it must be 8k?
>
> regards,
>   

