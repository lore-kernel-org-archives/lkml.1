Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXIHKWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXIHKWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXIHKWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:22:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39577 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbXIHKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:22:37 -0400
Date: Sat, 8 Sep 2007 11:30:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
Message-ID: <20070908113056.66fc97b7@the-village.bc.nu>
In-Reply-To: <200709081854.57549.nickpiggin@yahoo.com.au>
References: <200709071526.51169.jesse.barnes@intel.com>
	<200709081854.57549.nickpiggin@yahoo.com.au>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007 18:54:57 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Saturday 08 September 2007 08:26, Jesse Barnes wrote:
> > FYI, we just released a new white paper describing memory ordering for
> > Intel processors:
> > http://developer.intel.com/products/processor/manuals/index.htm
> >
> > Should help answer some questions about some of the ordering primitives
> > we use on i386 and x86_64.
> 
> So, can we finally noop smp_rmb and smp_wmb on x86?

Nakked-by: Alan Cox <alan@redhat.com>

You can only no-op it on 64bit Intel processors. On 32bit it needs to be
conditional on whether your processor family (or back compat for it) as
the Pentium Pro has some serious store ordering errata (hence the way it
needs lock decb for spin_unlock)

Alan
