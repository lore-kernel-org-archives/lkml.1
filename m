Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZAPAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZAPAaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZAPA3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:29:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZAPA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:29:52 -0500
Date: Thu, 15 Jan 2009 16:27:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: matthew@wil.cx, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
Subject: Re: Mainline kernel OLTP performance update
Message-Id: <20090115162735.99277cc9.akpm@linux-foundation.org>
In-Reply-To: <200901151824.38658.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<20090115012147.GW29283@parisc-linux.org>
	<20090114180431.f4a96543.akpm@linux-foundation.org>
	<200901151824.38658.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 18:24:36 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Given that SLAB and SLUB are fairly mature, I wonder what you'd think of
> taking SLQB into -mm and making it the default there for a while, to see
> if anybody reports a problem?

Nobody would test it in interesting ways.

We'd get more testing in linux-next, but still not enough, and not of
the right type.

It would be better to just make the desision, merge it and forge ahead.

Me, I'd be 100% behind the idea if it had a credible prospect of a net
reduction in the number of slab allocator implementations.

I guess the naming convention will limit us to 26 of them.  Fortunate
indeed that the kernel isn't written in cyrillic!


