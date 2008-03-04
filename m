Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYCDDR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYCDDR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYCDDRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:17:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYCDDRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:17:46 -0500
Date: Mon, 3 Mar 2008 19:17:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alpha: remove remaining __FUNCTION__ occurances
Message-Id: <20080303191717.cd7d9e81.akpm@linux-foundation.org>
In-Reply-To: <1204566919.3266.18.camel@brick>
References: <1204566919.3266.18.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 09:55:19 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> __FUNCTION__ is gcc-specific, use __func__
> 
> The change in pci-iommu,c should be safe as arena has not been assigned
> when we get to this point.
> 
> Some were within #if 0 blocks, have changed them and left the blocks
> as they appear to be debugging infrastructure.
> 
> A #define FN __FUNCTION__ was removed and occurances of FN were replaced
> with __func__ as well.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/alpha/kernel/core_marvel.c  |    6 +++---
>  arch/alpha/kernel/core_t2.c      |   24 +++++++++---------------
>  arch/alpha/kernel/core_titan.c   |   34 +++++++++++++++++-----------------
>  arch/alpha/kernel/core_tsunami.c |   28 +++++++++++++---------------
>  arch/alpha/kernel/pci.c          |    2 +-
>  arch/alpha/kernel/pci_iommu.c    |   34 +++++++++++++++-------------------
>  arch/alpha/kernel/smp.c          |    4 ++--
>  arch/alpha/kernel/srm_env.c      |    2 +-
>  arch/alpha/kernel/sys_alcor.c    |    2 +-
>  arch/alpha/kernel/sys_marvel.c   |   12 ++++++------
>  arch/alpha/kernel/sys_sable.c    |    6 +++---
>  arch/alpha/kernel/sys_sio.c      |    2 +-
>  drivers/video/i810/i810_main.c   |   32 +++++++++-----------------------

this stray-random-apparently-shouldnt-be-there change to i810_main.c
causes it to not compile.

