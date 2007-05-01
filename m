Return-Path: <linux-kernel-owner+w=401wt.eu-S965685AbXEAIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685AbXEAIsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXEAIsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:48:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250AbXEAIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:48:43 -0400
Date: Tue, 1 May 2007 09:48:41 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, greg@kroah.com
Subject: pci hotplug patches
Message-ID: <20070501084841.GC14364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, greg@kroah.com
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
>  remove-pci_dac_dma_-apis.patch
>  round_up-macro-cleanup-in-drivers-pci.patch
>  pcie-remove-spin_lock_unlocked.patch
>  cpqphp-partially-convert-to-use-the-kthread-api.patch
>  ibmphp-partially-convert-to-use-the-kthreads-api.patch
>  cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
>  msi-fix-arm-compile.patch
>  support-pci-mcfg-space-on-intel-i915-bridges.patch
>  pci-syscallc-switch-to-refcounting-api.patch
> 
> Stuff to (various levels of re-)send to Greg for the PCI tree.  I'll probably
> drop the kthread patches as they seemed a bit half-baked and I've lost track
> of which ones have which levels of baking.

All the partially kthread conversion were superceed with full conversion
from me.  I've only got feedback from the cpci maintainer, and he acked
my patch together with a simple fix from him.
