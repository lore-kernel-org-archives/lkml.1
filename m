Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbXJENl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbXJENl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXJENlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:41:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42952 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXJENlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:41:20 -0400
Message-ID: <47063EF3.4050302@bull.net>
Date: Fri, 05 Oct 2007 15:41:07 +0200
From: Valerie Clement <valerie.clement@bull.net>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
References: <4705113A.7030908@bull.net> <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 15:47:28,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 15:47:29,
	Serialize complete at 05/10/2007 15:47:29
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Thu, 2007-10-04 at 18:13 +0200, Valerie Clement wrote:
>> While running ffsb tests on my ext4 filesystem, I got an Oops in 
>> cache_alloc_refill().
>> I turned on SLAB debugging and here is the message I got:
>>
>> slab: Internal list corruption detected in cache 'buffer_head'(30), 
>> slabp ffff81007e100100(1515870810). Hexdump:
> 
> slabp->inuse = 1515870810 looks bogus. Is this easily reproducible ?

Hi Badari,
Thanks for your answer.
I didn't reproduce it without the latest ext4 patches. So I suspect a 
bug in one of them.
But how debugging this?
Which other debug traces can I turn on?

   Valérie

