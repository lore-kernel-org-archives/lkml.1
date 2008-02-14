Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbYBNU6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbYBNU6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYBNU6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:58:32 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:45198 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbYBNU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:58:31 -0500
In-Reply-To: <20080213.170938.34536425.davem@davemloft.net>
References: <20080213.170938.34536425.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Becky Bruce <becky.bruce@freescale.com>
Subject: Re: [PATCH 0/4]: Respun LMB patches.
Date: Thu, 14 Feb 2008 14:58:22 -0600
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13, 2008, at 7:09 PM, David Miller wrote:

>
> I've taken into consideration the various feedback, and
> ported the bug fix and other LMB patches posted recently
> in an effort to keep the patch churn by others down wrt.
> my moving of these files.
>
> 1) Use HAVE_LMB as suggested by Sam.
>
> 2) Fix potential build errors wrt. asm/prom.h dependencies.
>
>    My algorithm was:
>
>    a) If the file only included asm/lmb.h I added an include
>       of both linux/lmb.c and asm/prom.h
>
>    b) If the file already includes asm/prom.h, I merely
>       changed the asm/lmb.h to linux/lmb.h
>
>    Header include mimimizations can be done as followon patches.
>
> 3) Integrate Kumar Gala's initial region fix.
>
> 4) Integrate Becky Bruce's large physical addressing change,
>    but using u64 instead of phys_addr_t.
>
> It's all at:
>
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git
>
> like before.


Thanks for picking up the patches from Kumar and myself and fitting  
them into your series - this is much appreciated.  FYI, I applied the  
entire patch series to my local tree and test-booted both mpc8641 and  
mpc8568mds and both build and boot cleanly. I also built pasemi and  
ebony, those build cleanly as well.

Cheers,
Becky

