Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYKTO0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYKTO0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYKTOZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:25:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbYKTOZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:25:31 -0500
Subject: Re: [PATCH] intel-iommu: make init_dmars() static
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
In-Reply-To: <1227190873.3739.24.camel@blaa>
References: <1227190873.3739.24.camel@blaa>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 14:24:09 +0000
Message-Id: <1227191049.3739.28.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 14:21 +0000, Mark McLoughlin wrote:
> init_dmars() is not used outside of drivers/pci/intel-iommu.c

Note, most of linux/dma_remapping.h is only needed by intel-iommu.c

Any objections into moving all of that into intel-iommu.c?

Cheers,
Mark.

