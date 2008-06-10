Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYFJKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYFJKDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYFJKDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:03:04 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:52031 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753483AbYFJKDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:03:03 -0400
Date: Tue, 10 Jun 2008 11:02:50 +0100
From: Ben Dooks <ben@fluff.org>
To: Uli Luckas <u.luckas@road.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, adaplas@gmail.com,
       David Brownell <david-b@pacbell.net>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] Frame buffers and early i2c
Message-ID: <20080610100249.GA30539@fluff.org.uk>
References: <200806091647.42757.u.luckas@road.de> <200806092359.36080.u.luckas@road.de> <20080610082527.0e6d643a@hyperion.delvare> <200806101131.19763.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806101131.19763.u.luckas@road.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:31:19AM +0200, Uli Luckas wrote:
> On Tuesday, 10. June 2008, Jean Delvare wrote:
> > Hi Uli,
> >
> > On Mon, 9 Jun 2008 23:59:35 +0200, Uli Luckas wrote:
> > > On Monday 09 June 2008, Jean Delvare wrote:
> > > > Why don't you ask on the i2c mailing list? Cc added.
> > >
> > > I wanted to get i2c developers plus frame buffer and other i2c client
> > > developers involved. Crossposting to more then 2 lists seemed wrong.
> >
> > So you prefer to post to one random list than the two lists where your
> > target audience is? Interesting approach. If you really don't want to
> > post to two lists at once, just send two separate posts?
> >
> And have two seperate threads of communication??? lfml is where they all are 
> and avery maintainer has different preferences. Anyway, I got your point and 
> will come to the i2c list in the future if you prefere.
> 
> > > I'll change the pxa i2c driver to subsys_initcall and try if that works
> > > when I get back to my desk tomorrow.
> >
> > I expect it to work, as apparently other platforms are doing exactly
> > that already.
> >
> Just changing the initcall to subsys really did the trick. I thought, this was 
> the first thing I tried and I thought it crashed my device. But obviousely I 
> had some other problem.
> If Russell gives his Ack, could this be pushed upstream through i2c?

Does this work if the code is built as a module? 

BTW, if people do have these sort of dependencies, then modules
are another way of sorting out the load order, unless you have
the module autoload enabled.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
