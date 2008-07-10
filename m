Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYGJIen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYGJIen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGJIee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:34:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbYGJIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:34:33 -0400
Date: Thu, 10 Jul 2008 01:28:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-Id: <20080710012807.6a0e70b1.akpm@linux-foundation.org>
In-Reply-To: <20080710082336.GA31219@digi.com>
References: <20080625131101.GA6205@digi.com>
	<20080704104634.GA31634@digi.com>
	<20080704101717.28f6a771.akpm@linux-foundation.org>
	<20080704184307.GA8076@digi.com>
	<20080704120837.573adc9c.akpm@linux-foundation.org>
	<20080709131353.GA12009@digi.com>
	<20080709145253.f658db37.akpm@linux-foundation.org>
	<20080710082336.GA31219@digi.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 10:23:36 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:

> Hello,
> 
> Andrew Morton wrote:
> > > > However I'm presently brewing up a plot to do this:
> > > >
> > > >         printk("function name is %Ss\n", (unsigned long *)chip->set_type);
> > > >
> > > > which I think will work.  We can also do
> > > >
> > > >         printk("IP address is %Si\n", (unsigned long *)ip_address_buffer);
> > > >
> > > > to replace NIPQUAD.  And similar printk extensions.
> > > >
> > > > Am still thinking about it though.
> > > I assume the result is 0fe1ef24f7bd0020f29ffe287dfdb9ead33ca0b2?
> > 
> > yup.
> When I saw this commit I wondered that it was you who told me to think
> about this but the commiter was Linus.

A long story.  I rubbed a magic lantern ;)

> > > Should I send a new version using %pF or is it easier if you fix up the
> > > patch?
> > 
> > A new version would be nice, thanks.  Or an incremental diff, but I can and
> > will turn new versions into an incremental in the twinkle of an eye, so
> > either is OK.
> voila:

Thanks.

