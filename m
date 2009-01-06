Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZAFXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZAFXVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZAFXV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:21:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZAFXV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:21:27 -0500
Date: Tue, 6 Jan 2009 15:21:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106152123.a4bf1736.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > generic-swap-sparc-rename-swap-to-swap_ulong.patch
> > generic-swap-iphase-rename-swap-to-swap_byte_order.patch
> > generic-swap-lib-sortc-rename-swap-to-swap_func.patch
> > generic-swap-introduce-global-macro-swapa-b.patch
> > generic-swap-ext3-remove-local-swap-macro.patch
> > generic-swap-ext4-remove-local-swap-macro.patch
> > generic-swap-sched-remove-local-swap-macro.patch
> > generic-swap-dcache-use-swap-instead-of-private-do_switch.patch
> > 
> >   Add a kernel-wide swap() macro, use it.  Merge.
> 
> Hmm, must have missed this when it went to lkml.  Having this helper
> generic is a good idea, but swap is far too generic for something
> in kernel.h as indicated by the various renaming patches. How about
> swap_vars?
> 

I thought that swap() was a good name, actually.

Sure, it's bold.  But we only have one swap() implementation,
kernel-wide, forever, right?   So what the heck: call it swap()!
