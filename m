Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYJLTml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYJLTml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYJLTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:42:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44403
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbYJLTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:42:29 -0400
Date: Sun, 12 Oct 2008 12:42:05 -0700 (PDT)
Message-Id: <20081012.124205.193717562.davem@davemloft.net>
To: bunk@kernel.org
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: m68knommu, net and DMA compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081012111547.GE31153@cs181140183.pp.htv.fi>
References: <20081012111547.GE31153@cs181140183.pp.htv.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 12 Oct 2008 14:15:47 +0300

> In the CONFIG_PCI=n case (the PCI code will be removed during this merge 
> window) m68knommu does not set the Kconfig NO_DMA variable, but also 
> does not provide the required functions, resulting in the following 
> build error triggered by commit a40c24a13366e324bc0ff8c3bb107db89312c984
> (net: Add SKB DMA mapping helper functions.):

I would recommend that m68knommu set NO_DMA in it's arch Kconfig
