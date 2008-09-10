Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYIJECK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYIJECK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYIJEB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:01:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44033 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYIJEB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:01:56 -0400
Date: Tue, 9 Sep 2008 21:57:13 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jdmason@kudzu.us, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Calgary and bad_dma_address
Message-Id: <20080909215713.7ef0cfc4.zaitcev@redhat.com>
In-Reply-To: <20080909.203728.135352650.davem@davemloft.net>
References: <20080909211941.0a0fda6a.zaitcev@redhat.com>
	<20080909.203728.135352650.davem@davemloft.net>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 20:37:28 -0700 (PDT), David Miller <davem@davemloft.net> wrote:

> > I was reading arch/x86/kernel/pci-calgary_64.c today, and noticed that
> > apparently nothing prevents iommu_area_alloc from returning a zero.
> > But bad_dma_address is zero too. Doesn't it concern anyone?

> Won't the device range reserves done by calls of calgary_reserve_mem_region()
> take care of this?

Sorry, my mistake. Indeed it does, thanks.

-- Pete
