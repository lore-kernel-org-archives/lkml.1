Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXJILI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXJILI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXJILIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:08:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42948 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXJILIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:08:49 -0400
Date: Tue, 9 Oct 2007 13:08:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009110845.GA28570@one.firstfloor.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <p73sl4k4ofq.fsf@bingen.suse.de> <20071009100030.GA22475@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009100030.GA22475@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 12:00:30PM +0200, Sam Ravnborg wrote:
> On Tue, Oct 09, 2007 at 11:39:21AM +0200, Andi Kleen wrote:
> > Sam Ravnborg <sam@ravnborg.org> writes:
> > >  
> > > -ARCH		?= $(SUBARCH)
> > > -CROSS_COMPILE	?=
> > 
> > Can you do this in a way that there are still these ARCH/CROSS_COMPILE
> > lines that are just overriden when empty or have their default value? 
> > 
> > This way defaults could be still patched in for special cases.
> 
> If it is OK to drop the $(SUBARCH) assingment like this then yes.
> ARCH		?=
> CROSS_COMPILE	?=

As long as both UML and normal architectures work still out of the 
box yes

> I was wondering why we had the empty CROSS_COMPILE assigment and this
> explains why.
> But why patch something in here in the fisrt place?
> It seems to be a workaround for the actual issue this patch addresses - no?

Mostly.

The difference is that Kbuild.config would likely contain other stuff
too that might be not fit into a patch? Ok it's not a big difference.

-Andi

