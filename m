Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYJJCnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYJJCnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 22:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYJJCmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 22:42:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:49403 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYJJCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 22:42:49 -0400
Date: Fri, 10 Oct 2008 11:40:56 +0900
To: grundler@parisc-linux.org
Cc: yinghai@kernel.org, jbarnes@virtuousgeek.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081009211837.GC18444@colo.lackof.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	<20081009211837.GC18444@colo.lackof.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081010114002D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008 15:18:37 -0600
Grant Grundler <grundler@parisc-linux.org> wrote:

> On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
> > so can find out what is DMA mask is used for pci devices in addition to
> > default setting.
> 
> I like the idea. I don't like the additional boot time output.
> 
> But I'm thinking this could be an option to lspci.
> lspci already knows about the /sys tree. Can PCI export the two masks
> (dma_mask and dma_consistent_mask) and something like "lspci -td"
> would dump those in a nice way?
> 
> Anyone else agree?

Agreed.

dma_mask and dma_consistent_mask is not useful for the
majority. Printing them at boot time doesn't make sense for me.

Adding under sysfs and using lspci sounds reasonable if we really need
these information.
