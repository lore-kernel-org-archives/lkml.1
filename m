Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbXBNThF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbXBNThF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXBNThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:37:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42986 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbXBNThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:37:03 -0500
Date: Wed, 14 Feb 2007 19:36:26 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure, do individual functions
Message-ID: <20070214193626.GA18405@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Zachary Amsden <zach@vmware.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
	Chris Wright <chrisw@sous-sol.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D260A2.4010200@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 05:06:42PM -0800, Zachary Amsden wrote:
> >I moved drm_follow_page into the core, to avoid having to wrap the
> >various pte ops.  Unlining kernel_fpu_end and using that in the RAID6
> >code would remove the need to export clts/read_cr0/write_cr0 too.

Please don't push the drm_follow_page part.  Dave and I fixed drm
to not need this junk anymore, and it should be part of the next drm merge.

