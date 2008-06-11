Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYFKO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYFKO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYFKO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:26:41 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2881 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYFKO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:26:41 -0400
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200806101014.25089.jbarnes@virtuousgeek.org>
References: <20080526234940.GA1376@xs4all.net>
	 <1212682484.4332.7.camel@n2o.xs4all.nl> <20080610102347.GC19136@elte.hu>
	 <200806101014.25089.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Organization: XS4ALL Internet B.V.
Date: Wed, 11 Jun 2008 16:26:29 +0200
Message-Id: <1213194389.421.30.camel@n2o.xs4all.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 10:14 -0700, Jesse Barnes wrote:
> On Tuesday, June 10, 2008 3:23 am Ingo Molnar wrote:
> > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > > On Mon, 2008-06-02 at 12:15 +0200, Ingo Molnar wrote:
> > > > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > > > > Okay, so how about this then ?
> > > >
> > > > applied to tip/pci-for-jesse for more testing. Thanks,
> > >
> > > I've thought about it a bit more, and I think the actual patch that
> > > really does what everybody wants is this one instead:
> >
> > applied a delta patch version of the one below to tip/pci-for-jesse.
> 
> Speaking of that branch, how do you want to handle it?  Is it intended for my 
> linux-next branch or are some of the fixes important to get upstream now?  
> Which branch should I diff/log against to see the changes (last time I looked 
> it appeared neither master nor tip were the correct ones...)

My opinion is that this particular patch should go into 2.6.26.

Mike.

