Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbXDMR6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbXDMR6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXDMR6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:58:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbXDMR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:58:15 -0400
Date: Fri, 13 Apr 2007 10:58:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-Id: <20070413105808.28bf39ae.akpm@linux-foundation.org>
In-Reply-To: <20070413172450.GQ11115@waste.org>
References: <1.486631555@selenic.com>
	<20070412231050.GN2986@holomorphy.com>
	<20070412163235.dd030637.akpm@linux-foundation.org>
	<461ECB9C.8060000@yahoo.com.au>
	<20070412174201.065068b2.akpm@linux-foundation.org>
	<20070413162436.GO11115@waste.org>
	<20070413100356.62c6d9c2.akpm@linux-foundation.org>
	<20070413172450.GQ11115@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 12:24:51 -0500 Matt Mackall <mpm@selenic.com> wrote:

> > > From /proc/kpagemap + /proc/*/pagemap, you can
> > > basically synthesize any statistic you want, including all the
> > > existing ones. For some data, /proc/pid/smaps (or /proc/meminfo) will
> > > be considerably more efficient.
> > 
> > You'd need to poke clear_refs beforehand to make the referenced bits useful.
> > 
> > Actually, we also need to run around the ptes and collect the pte-referenced
> > bits too.  I don't think your code copes with any of that?
> 
> No, and it probably should. Perhaps dirty as well, though I've kindof
> lost the plot on how that works lately.

Dirty is OK: the VM keeps pte-dirtiness and page-dirtiness in sync now.
