Return-Path: <linux-kernel-owner+w=401wt.eu-S939029AbXG3QvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939029AbXG3QvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbXG3QvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:51:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51755 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761023AbXG3QvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:51:06 -0400
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Jacob Braun <jwbraun@gmail.com>, kriko <kristjan.ugrin@gmail.com>,
       ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site>
	 <d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com>
	 <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 18:50:28 +0200
Message-Id: <1185814234.16771.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 02:25 +1000, Matthew Hawkins wrote:
> On 7/31/07, Jacob Braun <jwbraun@gmail.com> wrote:
> > On 7/30/07, kriko <kristjan.ugrin@gmail.com> wrote:
> > > I would try the new cfs how it performs, but it seems that nvidia drivers
> > > doesn't compile successfully under 2.6.23-rc1.
> > > http://files.myopera.com/kriko/files/nvidia-installer.log
> > >
> > > If someone has the solution, please share.
> >
> > There is a patch for the nvidia drivers here:
> > http://bugs.gentoo.org/attachment.cgi?id=125959
> 
> The ATI drivers (current 8.39.4) were broken by
> commit e21ea246bce5bb93dd822de420172ec280aed492
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Bad call on the "nobody was using these", Martin :(

Nobody in the upstream kernel did, and that is what matters. If you care
about your kernel code get it upstream.

As for breaking binary crap, thats a bonus. Break them hard, break them
often.

Kudos to Martin.

