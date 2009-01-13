Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbZAMIx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbZAMIx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZAMIxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:53:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754AbZAMIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:53:04 -0500
Date: Tue, 13 Jan 2009 00:51:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
 dma_debug_entries
Message-Id: <20090113005118.82f5037b.akpm@linux-foundation.org>
In-Reply-To: <1231517970-20288-4-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	<1231517970-20288-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 17:19:17 +0100 Joerg Roedel <joerg.roedel@amd.com> wrote:

> +struct hash_bucket {
> +	struct list_head list;
> +	spinlock_t lock;
> +} ____cacheline_aligned;

__cacheline_aligned_in_smp.

This all looks like an exotically large amount of code for a debug thingy?
