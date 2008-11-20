Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYKTOO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYKTOO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYKTOOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:14:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYKTOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:14:50 -0500
Subject: Re: [PATCH] intel-iommu: remove some unused struct intel_iommu
	fields
From: David Woodhouse <dwmw2@infradead.org>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
In-Reply-To: <1227189860.3739.21.camel@blaa>
References: <1227189860.3739.21.camel@blaa>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 14:14:38 +0000
Message-Id: <1227190478.4901.20.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 14:04 +0000, Mark McLoughlin wrote:
> The seg, saved_msg and sysdev fields appear to be unused since
> before the code was first merged.
> 
> linux/msi.h is not needed in linux/intel-iommu.h anymore since
> there is no longer a reference to struct msi_msg. The MSI code
> in drivers/pci/intel-iommu.c still has linux/msi.h included
> via linux/dmar.h.
> 
> linux/sysdev.h isn't needed because there is no reference to
> struct sys_device.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

Applied; thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

