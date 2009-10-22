Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZJVPtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZJVPtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZJVPtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:49:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbZJVPtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:49:51 -0400
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
In-Reply-To: <1256182910.2842.36.camel@2710p.home>
References: <1256182910.2842.36.camel@2710p.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 00:49:51 +0900
Message-Id: <1256226591.2990.88.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 21:41 -0600, Alex Williamson wrote:
> This device also doesn't exactly play nice when using VT-d in anything other
> than pass-through mode, so switching it into mapped mode is not really
> an option.

Going back to this, now I'm slightly more awake and spotted it...

Er, why? Can you define "doesn't exactly play nice"?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

