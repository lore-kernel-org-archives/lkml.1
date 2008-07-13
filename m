Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYGMVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYGMVXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYGMVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbYGMVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:23:42 -0400
Date: Sun, 13 Jul 2008 14:23:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Message-Id: <20080713142317.97111c81.akpm@linux-foundation.org>
In-Reply-To: <200807131412.32961.david-b@pacbell.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
	<20080708134336.GA6240@doriath.ww600.siemens.net>
	<20080712234823.e632c7f9.akpm@linux-foundation.org>
	<200807131412.32961.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 14:12:32 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Saturday 12 July 2008, Andrew Morton wrote:
> > > +EXPORT_SYMBOL(clk_get_parent);
> > 
> > As this is a new kernel-wide utility library, it is appropriate that
> > all of its public interfaces (at least) be documented. __An appropriate
> > way of doing that is via kerneldoc annotation. __Please don't forget to
> > document return values and call environment prerequisites (eg: requires
> > foo_lock, may be called from interrupt context, etc, etc).
> 
> That is, the stuff that's not already documented in <linux/clk.h>;
> that's where clk_get_parent() is documented, for example.

argh.  That's why I missed it - please don't document stuff in header
files.  The usual approach is to document interfaces at the
implementation site.

Except for structs where of course there is no choice.  But then,
the .h file _is_ the definition site.

