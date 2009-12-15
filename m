Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZLOL1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZLOL1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZLOL1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:27:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:55359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZLOL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:27:41 -0500
Message-ID: <4B277235.4010308@kernel.org>
Date: Tue, 15 Dec 2009 03:25:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
References: <4B2752A9.10903@kernel.org>	<20091215182243R.fujita.tomonori@lab.ntt.co.jp>	<20091215105650.GA13214@elte.hu> <20091215201039V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091215201039V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 15 Dec 2009 11:56:50 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>
>>> There are a few people who hit this. How many people use a box with over 
>>> 256GB memory?
>>>
>>> And you can work around this with "dma32_size" kernel boot option.
>> Well, since the kernel has not crashed before this change there's really just 
>> two options as per upstream kernel regression policy: either we fix it or we 
>> revert it.
> 
> As I wrote, here is a patch that can be applied to cleanly to the git
> head:
> 
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch
> 
> It fixes the problem. Yinghai, can you test it? It should work but
> it's good to confirm it.

i tested already, it works.

> 
> I simply wanted to say that it's not a bug that breaks lots of boxes
> or leads to something serious like data corruption (no need to say
> something like "revert it now!"). It's also worth investigating why it
> breaks, I think.

will look at it later

YH

