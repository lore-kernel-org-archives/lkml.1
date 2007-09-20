Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXITXou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXITXou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXITXon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:44:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47714 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXITXon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:44:43 -0400
Date: Fri, 21 Sep 2007 01:44:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070920234441.GK18707@one.firstfloor.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <20070920230304.GJ18707@one.firstfloor.org> <20070920233114.GR4219@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920233114.GR4219@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 06:31:14PM -0500, Matt Mackall wrote:
> On Fri, Sep 21, 2007 at 01:03:04AM +0200, Andi Kleen wrote:
> > > It's broken for me.
> > > 
> > > 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
> > >       -rc4-mm1: solid lock on X shutdown, random solid locks about
> > >                 once every four hours
> > >       -rc6-mm1: solid lock on X startup
> > >    +your patch: screen goes black, turns off and on a few times during
> > >                 startup, can reboot with sysrq-b
> > 
> > Does it work with my simple dumb patch instead of Dave's ? 
> 
> Sorry, forgot to mention: your one-liner flush also doesn't work (same
> behavior).
> 
> I suspect I'm tripping two things and the flushing thing fixes one but
> not the other.

Full bisect needed then I guess. Ok as a short cut you could perhaps
the cpa-* patches first (might need to drop some later depending 
patches), then the drm and agp trees.

-Andi
