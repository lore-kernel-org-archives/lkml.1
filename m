Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbXFRSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbXFRSiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbXFRSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:37:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47548 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761290AbXFRSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:37:58 -0400
Date: Mon, 18 Jun 2007 19:37:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [patch] use __asm__ and __volatile__ in asm-ia64/gcc_intrin.h
Message-ID: <20070618183754.GC17112@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, tony.luck@intel.com
References: <200706180219.11164.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706180219.11164.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:19:10AM -0400, Mike Frysinger wrote:
> Since asm-ia64/gcc_intrin.h gets exported to userspace, we need to make sure
> to use __asm__() rather than asm() since the latter is not available when
> compiling with gcc with GNU extensions turned off (like -std=c99).

This header is only for kernel-internal use and should not be exported
to userspace at all.
