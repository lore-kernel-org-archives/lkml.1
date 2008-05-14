Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYENG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYENG55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYENG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:57:50 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:40530 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYENG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:57:49 -0400
Date: Wed, 14 May 2008 08:55:45 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 2/2] x86: per-device dma_mapping_ops support
Message-ID: <20080514055545.GE6682@il.ibm.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1210658692-960-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210658692-960-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:04:52PM +0900, FUJITA Tomonori wrote:
> This adds per-device dma_mapping_ops support for CONFIG_X86_64.
> 
> A pointer to dma_mapping_ops to struct dev_archdata is added. If the
> pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
> it's NULL, the system-wide dma_ops pointer is used as before.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
