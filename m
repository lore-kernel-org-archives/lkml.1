Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXDMHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXDMHvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXDMHvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:51:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45601 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXDMHvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:51:50 -0400
Date: Fri, 13 Apr 2007 08:51:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413075142.GA23822@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461F2BCB.2020200@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 05:05:47PM +1000, Nick Piggin wrote:
> Ah, OK. Anyway, with kprobes/systemtap they can do whatever they like
> and none of us need to care in the slightest ;)

Umm, folks.  systemtap basically means people compile kernel modules
from an odd scripting language with embedded C snipplets into kernel
modules.  The kernel modules don't use normal exported APIs but use
kallsysms and dwarf info to poke into every possible private bit.

Saying you don't care the slightest whether oracle will load huge
amounts of code into the kernel that depends on intimate implementation
details, and that you don't even have source to to debug it is not what
I'd call "none of us need to care in the slightest", at least for those
of you working for distributions that may actually have to debug this
shit in the end.

While we're at it, what happened to the idea of tainting the kernel
as soon as krpobes are placed in the kernel to at least make people
aware of it?

