Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZEKOQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZEKOQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZEKOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:16:19 -0400
Received: from 8bytes.org ([88.198.83.132]:34600 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbZEKOQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:16:18 -0400
Date: Mon, 11 May 2009 16:16:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 4/9] xen/swiotlb: add swiotlb_arch_range_needs_mapping
	hook for xen
Message-ID: <20090511141616.GC8671@8bytes.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <1241741842-7966-5-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241741842-7966-5-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:17:17PM -0700, Jeremy Fitzhardinge wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: Xen support for DMA
> 
> Add hook so that Xen can determine whether a particular address range needs
> pfn<->mfn mapping.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
