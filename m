Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYFJRPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYFJRPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYFJROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:14:42 -0400
Received: from outbound-mail-129.bluehost.com ([67.222.38.29]:40990 "HELO
	outbound-mail-129.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756638AbYFJROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:14:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Date: Tue, 10 Jun 2008 10:14:24 -0700
User-Agent: KMail/1.9.9
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-kernel@vger.kernel.org
References: <20080526234940.GA1376@xs4all.net> <1212682484.4332.7.camel@n2o.xs4all.nl> <20080610102347.GC19136@elte.hu>
In-Reply-To: <20080610102347.GC19136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101014.25089.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 3:23 am Ingo Molnar wrote:
> * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > On Mon, 2008-06-02 at 12:15 +0200, Ingo Molnar wrote:
> > > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > > > Okay, so how about this then ?
> > >
> > > applied to tip/pci-for-jesse for more testing. Thanks,
> >
> > I've thought about it a bit more, and I think the actual patch that
> > really does what everybody wants is this one instead:
>
> applied a delta patch version of the one below to tip/pci-for-jesse.

Speaking of that branch, how do you want to handle it?  Is it intended for my 
linux-next branch or are some of the fixes important to get upstream now?  
Which branch should I diff/log against to see the changes (last time I looked 
it appeared neither master nor tip were the correct ones...)

Thanks,
Jesse
