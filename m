Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZHAPw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZHAPw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZHAPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:52:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZHAPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:52:27 -0400
Date: Sat, 1 Aug 2009 11:52:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jim Paradis <jparadis@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Dirty page tracking & on-the-fly memory mirroring
Message-ID: <20090801155227.GB10888@infradead.org>
References: <4A7393D9.50807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7393D9.50807@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 09:01:13PM -0400, Jim Paradis wrote:
>
> This patch is a reference implementation of a memory-mirroring module
> ("pagesync").  It is the same code that Stratus uses minus some
> hardware-specific bits.  This module scans through physical memory,
> clearing the hardware dirty bit of any dirty page and setting the
> software dirty bit.  If a dirty page has the *hardware* dirty bit
> set on a subsequent scan, we know that the page has been re-dirtied
> and it is a candidate for being copied again.

As mentioned in the prevois mail example code is uttely useless.  Please
post the real code for the stratus hardware, and also make in built-in
instead of opening big holes for external propritary modules.
