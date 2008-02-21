Return-Path: <linux-kernel-owner+w=401wt.eu-S1763711AbYBUGzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763711AbYBUGzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYBUGzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:55:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbYBUGzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:55:32 -0500
Date: Wed, 20 Feb 2008 22:56:09 -0800 (PST)
Message-Id: <20080220.225609.62017835.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: tomof@acm.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080219195758V.fujita.tomonori@lab.ntt.co.jp>
References: <20080216150341A.tomof@acm.org>
	<20080217.234142.157527607.davem@davemloft.net>
	<20080219195758V.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 19 Feb 2008 19:57:58 +0900

> On Sun, 17 Feb 2008 23:41:42 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: FUJITA Tomonori <tomof@acm.org>
> > Date: Sat, 16 Feb 2008 15:03:43 +0900
> > 
> > > [PATCH] sparc64: make IOMMU code respect the segment boundary limits
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > Looks good, but I think it will break sound for some ALI chips.
> > 
> > Please see arch/sparc64/kernel/pci.c:ali_sound_dma_hack()
> > and it's caller pci_dma_supported().
> 
> Could you explain the problem a little more?

Sorry, I was thinking of a different problem (for when I add
dma mask support to this code).

I will apply your patch, thanks!
