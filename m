Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYCKSeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYCKSeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYCKSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:34:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:49473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYCKSei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:34:38 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       pasemi-linux@ozlabs.org, Olof Johansson <olof@lixom.net>
Message-Id: <F4B05C0E-99BB-4F60-BDD8-A79F07A81692@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1205259311.26723.40.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
Date: Tue, 11 Mar 2008 13:29:14 -0500
References: <20080306233900.GA3969@lixom.net> <20080311000619.ba39311f.akpm@linux-foundation.org> <20080311142545.GA18843@lixom.net> <20080311105355.64a9c380.akpm@linux-foundation.org> <1205259311.26723.40.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Also this driver from git-md-accel is pretty sick:
>>>>
>>>>
>>>> drivers/dma/fsldma.c:439: warning: comparison of distinct pointer  
>>>> types lacks a cast
>>>> drivers/dma/fsldma.c: In function `fsl_chan_xfer_ld_queue':
>>>> drivers/dma/fsldma.c:584: warning: long long unsigned int format,  
>>>> dma_addr_t arg (arg 4)
>>>> drivers/dma/fsldma.c: In function `fsl_dma_chan_do_interrupt':
>>>> drivers/dma/fsldma.c:661: warning: unsigned int format, different  
>>>> type arg (arg 5)
>>>> drivers/dma/fsldma.c:677: warning: long long unsigned int format,  
>>>> dma_addr_t arg (arg 4)
>>>> drivers/dma/fsldma.c:677: warning: long long unsigned int format,  
>>>> dma_addr_t arg (arg 5)
>>>> drivers/dma/fsldma.c:694: warning: unsigned int format, different  
>>>> type arg (arg 4)
>>>> drivers/dma/fsldma.c: In function `fsl_dma_self_test':
>>>> drivers/dma/fsldma.c:833: warning: int format, different type arg  
>>>> (arg 5)
>>>> drivers/dma/fsldma.c: In function `of_fsl_dma_probe':
>>>> drivers/dma/fsldma.c:1003: warning: unsigned int format,  
>>>> different type arg (arg 5)
>>>> drivers/dma/fsldma.c: At top level:
>>>> drivers/dma/fsldma.c:723: warning: 'fsl_dma_callback_test'  
>>>> defined but not used
>>>
>>> Yeah, Zhang Wei posted a patch for that on lkml yesterday.
>>
>> OK.
>
> My fault for not pushing out this cleanup to the old url while the
> git-md-accel changeover was pending.

Any reason not to push Zhang's fixes for 2.6.25?

I also have a patch I want to push for 2.6.25 to deal with the powerpc  
device tree.  I was going to handle this via the powerpc tree's since  
that seems to be the model we have used for netdev and other drivers  
that play with arch/powerpc.  I hope that's not an issue (I'll CC you  
on the patch).

- k
