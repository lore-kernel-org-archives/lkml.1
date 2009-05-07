Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZEGI2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZEGI2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZEGI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:28:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbZEGI2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:28:25 -0400
Message-ID: <4A029BE1.4090309@cn.fujitsu.com>
Date: Thu, 07 May 2009 16:29:21 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp> <20090506223452.65e545d8.akpm@linux-foundation.org>
In-Reply-To: <20090506223452.65e545d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 7 May 2009 14:14:16 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> We replaced all DMA_nBIT_MASK macros with DMA_BIT_MASK(n) but why do
>> we still keep DMA_nBIT_MASK macros in include/linux/dma-mapping.h?
>>
>> As long as these macros exist, people use them. The current git has
>> two users and linux-next have other users.
>>
>> Is it better to remove DMA_nBIT_MASK macros completely now?
> 
> Yes, the plan is to remove them.
> 
> Doing so will break lots and lots of out-of-tree drivers, causing
> people some grief.  Is there any way in which we can cause their use to
> cause __deprecated warnings for a couple of months, to give people a
> chance to migrate?
> 
> 

Shall we use something like below to warn people?
#define DMA_64BIT_MASK	DMA_BIT_MASK(64);(__deprecated warnings:use DMA_BIT_MASK(64) instead) ?

-- 
Regards
Yang Hongyang
