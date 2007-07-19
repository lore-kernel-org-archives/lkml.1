Return-Path: <linux-kernel-owner+w=401wt.eu-S938366AbXGSOwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938366AbXGSOwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbXGSOwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:52:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXGSOwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:52:33 -0400
Date: Thu, 19 Jul 2007 15:52:29 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: wli@holomorphy.com, lkml@rtr.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] [7/48] i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070719145229.GA19858@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, wli@holomorphy.com, lkml@rtr.ca,
	linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134836.0C54214E6E@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719134836.0C54214E6E@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 03:48:36PM +0200, Andi Kleen wrote:
> 
> From: William Lee Irwin III <wli@holomorphy.com>
> 
> PAE is useful for more than supporting more than 4GB RAM.  It supports
> expanded swapspace and NX executable protections.  Some users may want NX
> or expanded swapspace support without the overhead or instability of
> highmem.  For these reasons, the following patch divorces CONFIG_X86_PAE
> from CONFIG_HIGHMEM64G.

What overhead of instability of highmem?  Sorry folks but this is utter
bollocks.  Back in the Caldera days we did a lot of measurement on highmem
overhead, and CONFIG_HIGHMEM has no measurable overhead at all on a system
that doesn't use it.  CONFIG_HIGHMEM64G on the other hand has
a quite visible overhead on small systems, but that's entirely due to the
bigger page table entries that you need for NX.

