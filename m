Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYIVSga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYIVSga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYIVSgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:36:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYIVSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:36:18 -0400
Date: Mon, 22 Sep 2008 11:36:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
Message-ID: <20080922113619.5075e7e4@infradead.org>
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 20:21:12 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patch series implements stackable dma_ops on x86. This is useful
> to be able to fall back to a different dma_ops implementation if one
> can not handle a particular device (as necessary for example with
> paravirtualized device passthrough or if a hardware IOMMU only
> handles a subset of available devices).

isn't the right answer here to have a per device DMA ops instead ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
