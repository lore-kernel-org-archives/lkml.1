Return-Path: <linux-kernel-owner+w=401wt.eu-S934570AbXHVWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570AbXHVWV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbXHVWVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:21:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:38933 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500AbXHVWVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:21:04 -0400
Date: Wed, 22 Aug 2007 15:20:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: James Courtier-Dutton <James@superbug.co.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822222036.GD3672@sequoia.sous-sol.org>
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CCB56F.8090308@superbug.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* James Courtier-Dutton (James@superbug.co.uk) wrote:
> If one could directly expose a device to the guest, this feature could
> be extremely useful for me.
> Is it possible? How would it manage to handle the DMA bus mastering?

Yes it's possible (Xen supports pci pass through).  Without an IOMMU
(like Intel VT-d or AMD IOMMU) it's not DMA safe.

thanks,
-chris
