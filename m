Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbXE2Wwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbXE2Wwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXE2Wwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:52:37 -0400
Received: from mxfep01.bredband.com ([195.54.107.70]:53114 "EHLO
	mxfep01.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXE2Wwg (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:52:36 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Ian Kumlien <iank@bredband.net>
To: David Miller <davem@davemloft.net>
Cc: michal.k.k.piotrowski@gmail.com, Linux-kernel@vger.kernel.org
In-Reply-To: <20070529.154406.104042418.davem@davemloft.net>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <20070529.153723.108751260.davem@davemloft.net>
	 <6bffcb0e0705291541q7e6d6faen5cd6345074c4c92a@mail.gmail.com>
	 <20070529.154406.104042418.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:51:52 +0200
Message-Id: <1180479122.19814.8.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On tis, 2007-05-29 at 15:44 -0700, David Miller wrote:
> From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
> Date: Wed, 30 May 2007 00:41:46 +0200
> 
> > On 30/05/07, David Miller <davem@davemloft.net> wrote:
> > > From: Ian Kumlien <iank@bredband.net>
> > > Date: Tue, 29 May 2007 23:38:48 +0200
> > >
> > > > As the daystar sets, i try to play some with my new would be
> > > > firewall/server, but since this will be running for quite some time i
> > > > have been experimenting with powertop to find out what i can do to limit
> > > > it's power usage.
> > > >
> > > > But, if i run powertop for too long or a few times to many... this
> > > > happens:
> > > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > > >
> > > > If i don't run powertop, it is rock solid... Compiling for hours,
> > > > running memtest for hours etc etc...
> > >
> > > I see this same exact problem on sparc64.
> > 
> > Have you tried this patch?
> > http://lkml.org/lkml/2007/5/29/392
> 
> Of course, I worked with Thomas on the fix :-)

I dunno if this applies to me, i run a 32 bit userspace...

-- 
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net
