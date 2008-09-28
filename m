Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbYI1OYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbYI1OYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYI1OYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 10:24:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:32896 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYI1OYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 10:24:06 -0400
Date: Sun, 28 Sep 2008 23:21:26 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080928232129J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 20:21:12 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patch series implements stackable dma_ops on x86. This is useful to
> be able to fall back to a different dma_ops implementation if one can
> not handle a particular device (as necessary for example with
> paravirtualized device passthrough or if a hardware IOMMU only handles a
> subset of available devices).

We already handle the latter. This patchset is more flexible but
seems to incur more overheads.

This feature will be used for only paravirtualized device passthrough?
If so, I feel that there is more simpler (and specific) solutions for
it.
