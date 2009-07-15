Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZGOH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZGOH3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZGOH3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:29:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZGOH3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:29:22 -0400
Subject: Re: linux-next: dwmw2-iommu tree build failure
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090715140116.c2ce8fde.sfr@canb.auug.org.au>
References: <20090715140116.c2ce8fde.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 08:29:19 +0100
Message-Id: <1247642959.10050.220.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 14:01 +1000, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/pci/intel-iommu.c: In function 'dmar_init_reserved_ranges':
> drivers/pci/intel-iommu.c:1323: error: 'struct iova_domain' has no member named 'iova_alloc_lock'
> 
> Caused by commit b25c32b0af7045d3837c44d9685358aeeb9b7ac8 ("intel-iommu:
> Remove superfluous iova_alloc_lock from IOVA code").

Oops, I need to kill the lockdep references to that lock too. Fixed now;
thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

