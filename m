Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYIPO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYIPO1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYIPO1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:27:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYIPO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:27:12 -0400
Subject: Re: [PATCH] introduce boot_printk()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jbaron <jbaron@redhat.com>
In-Reply-To: <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
References: <1221465916-30889-1-git-send-email-yhlu.kernel@gmail.com>
	 <48CE983C.8040709@zytor.com>
	 <86802c440809151018k2c7874dfjc8e9791bee9365f9@mail.gmail.com>
	 <48CE9A5C.1030603@zytor.com>
	 <86802c440809151034ycd6442me679792880b03320@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:26:36 +0200
Message-Id: <1221575196.6943.24.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 10:34 -0700, Yinghai Lu wrote:
> On Mon, Sep 15, 2008 at 10:24 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Yinghai Lu wrote:
> >>
> >> some guys complained that it is even too verbose with KERN_DEBUG
> >>
> >
> > I can understand the desire to enable filtering on a subsystem-by-subsystem
> > basis, but I think rather than doing a subsystem-specific hack we should do
> > something that any subsystem can use.
> >
> > Perhaps we could extend the current <level> hack to include a subsystem,
> > something like:
> >
> > <7><x86>Your blort driver seems to be befudged, trying blarfing.
> >
> > ... and something like "loglevel=x86:7,acpi:3,..."
> >
> sounds good.
> 
> every subsystem will have
> x86_printk
> acpi_printk
> pci_printk

doesn't sound like an easily extensible interface, better would be
extending printk with a KERN_subsys tag like proposed.

Perhaps Jason has better ideas - iirc he worked on something similar.

