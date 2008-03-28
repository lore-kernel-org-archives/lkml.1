Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYC1CmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYC1CmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYC1Clr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:41:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:57156 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbYC1Cln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:41:43 -0400
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Message-Id: <EA08C942-E156-410D-8ADA-7A4812B20221@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <1206664759.19368.11.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 4/5] [PPC] update lmb for hotplug memory add/remove
Date: Thu, 27 Mar 2008 21:40:52 -0500
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com> <1206664759.19368.11.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 27, 2008, at 7:39 PM, Badari Pulavarty wrote:
> ppc kernel maintains information about logical memory blocks in
> lmb.memory structure at the boot time. Its not updated for
> hotplug memory add/remove. hotplug memory notifier for memory
> add/remove now updates lmb.memory.
>
> This information is useful for eHEA driver to find out the memory
> layout and holes.
>
> NOTE: No special locking is needed for lmb_add() and lmb_remove().
> Calls to these are serialized by caller. (pSeries_reconfig_chain).
>
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> ---
> arch/powerpc/platforms/pseries/hotplug-memory.c |   43 +++++++++++++++
> include/linux/lmb.h                             |    3 -
> lib/lmb.c                                       |   66 ++++++++++++++ 
> ++++++----
> 3 files changed, 102 insertions(+), 10 deletions(-)

How is lmb_remove different than lmb_alloc?

- k
