Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbYHaTqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbYHaTqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYHaTqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:46:21 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56063 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYHaTqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:46:20 -0400
Date: Sun, 31 Aug 2008 15:46:09 -0400
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Tom Tucker <tom@opengridcomputing.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
Message-ID: <20080831194609.GC14876@fieldses.org>
References: <1219605422.14389.2.camel@localhost> <1219605596.14389.5.camel@localhost> <1219615789.27921.152.camel@localhost.localdomain> <1219616136.14389.12.camel@localhost> <48B2D7F8.5020206@opengridcomputing.com> <20080826192711.GJ4380@fieldses.org> <48B567F5.2090605@opengridcomputing.com> <1220111261.31172.14.camel@localhost.localdomain> <20080831193037.GB14876@fieldses.org> <1220211842.31172.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220211842.31172.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 08:44:02PM +0100, Ian Campbell wrote:
> On Sun, 2008-08-31 at 15:30 -0400, J. Bruce Fields wrote:
> > On Sat, Aug 30, 2008 at 04:47:41PM +0100, Ian Campbell wrote:
> > > On Wed, 2008-08-27 at 09:43 -0500, Tom Tucker wrote:
> > > > Sure. I've actually tried to reproduce it here unsuccessfully.
> > > > 
> > > > As a starter, I would suggest turning on transport debugging:
> > > > 
> > > > # echo 256 > /proc/sys/sunrpc/rpc_debug
> > > > [...]
> > > > If Ian is willing to create the log (or already has one), I'm
> > > > certainly willing to look at it.
> > > 
> > > It produced only the following (is that what was expected?):
> > > 
> > > [146866.448112] -pid- proc flgs status -client- -prog- --rqstp- -timeout -rpcwait -action- ---ops--
> > > [146866.448112] 30576 0001 00a0      0 f77a1600 100003 f7903340    15000 xprt_pending fa0ba88e fa0c9df4
> > > [146866.448112] 30577 0004 0080    -11 f77a1600 100003 f7903000        0 xprt_sending fa0ba88e fa0c9df4
> > 
> > It's normal to get something like that when you turn it on, yes (unless
> > someone else spots anything odd about that...) but what's really needed
> > is to turn this on and then reproduce the problem--it's the debugging
> > output that goes to the logs during the problem that'll be interesting.
> 
> That's what I did. The first time I did the echo I just got the header
> line, then I waited for the repro and since there had been no further
> logging I ran the echo again and got the three lines above.
> 
> Sounds like you expected there to be more and ongoing logging?

Yes.  It's the server side we're interested in, by the way--are you
collecting this deubgging on the client?

--b.
