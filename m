Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXFLW46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXFLW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXFLW4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:56:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33063 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753509AbXFLW4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:56:50 -0400
Date: Wed, 13 Jun 2007 00:57:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] #if 0
	mm/backing-dev.c:congestion_wait_interruptible()
Message-ID: <20070612225701.GY3588@stusta.de>
References: <20070612110733.GU3588@stusta.de> <9a8748490706120540p29d00d3cg9d8a4def0d57b783@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a8748490706120540p29d00d3cg9d8a4def0d57b783@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 02:40:06PM +0200, Jesper Juhl wrote:
> On 12/06/07, Adrian Bunk <bunk@stusta.de> wrote:
>> congestion_wait_interruptible() is no longer used.
>>
> Remind me again why it is that we add all these  #if 0  blocks instead
> of simply removing the unused code?
>
> It's just creating a janitorial task to go and remove all the #if 0
> bits at a later time, seems like pointless churn to me. If the code
> needs to go, let's just get rid of it in one go instead of two.

The #if 0 also handles all "I want to use this code in 6 months" 
comments that might come (and in some rare cases it even gets used 
later).

My primary intention is to remove dead code from bloating the kernel 
image, and this way the probability of patch acceptance is higher.

> Jesper Juhl

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

