Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZAIR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZAIR7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZAIR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:58:44 -0500
Received: from tservice.net.ru ([195.178.208.66]:49702 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbZAIR6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:58:43 -0500
Date: Fri, 9 Jan 2009 20:58:42 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 05/16] dma-debug: add initialization code
Message-ID: <20090109175842.GC30168@ioremap.net>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-6-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231517970-20288-6-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 05:19:19PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
 +static int prealloc_memory(u32 num_entries)
> +{
> +	struct dma_debug_entry *entry, *next_entry;
> +	int i;
> +
> +	for (i = 0; i < num_entries; ++i) {
> +		entry = kmalloc(sizeof(*entry), GFP_KERNEL | __GFP_ZERO);

kzalloc?


-- 
	Evgeniy Polyakov
