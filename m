Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbYLXVHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbYLXVHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLXVHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:07:45 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:51105 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbYLXVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:07:44 -0500
Date: Thu, 25 Dec 2008 00:07:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
	managing endpoint queues
Message-ID: <20081224210743.GA16098@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru> <20081224191303.GA21815@oksana.dev.rtsoft.ru> <20081224195935.GA11531@kroah.com> <20081224200845.GA1064@oksana.dev.rtsoft.ru> <20081224121853.b46e9174.akpm@linux-foundation.org> <20081224205835.GA14844@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081224205835.GA14844@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 12:58:35PM -0800, Greg KH wrote:
> On Wed, Dec 24, 2008 at 12:18:53PM -0800, Andrew Morton wrote:
> > On Wed, 24 Dec 2008 23:08:45 +0300 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > On Wed, Dec 24, 2008 at 11:59:36AM -0800, Greg KH wrote:
> > > > On Wed, Dec 24, 2008 at 10:13:03PM +0300, Anton Vorontsov wrote:
> > > > > Follow these changes for the FHCI driver:
> > > > 
> > > > Hm, would it just make more sense to respin the whole driver?  That way
> > > > it's never in the tree in a "broken" state?
> > > 
> > > It's for -mm tree. If I understand -mm workflow correctly, Andrew
> > > will merge all the fixes into the final patch before sending it to
> > > you in late -rc0 phase, when various -next git trees (on which this
> > > driver depend) will be merged into the Linus tree.
> > >
> > > Andrew, am I correct?
> > 
> > Yes, that's what I do.
> > 
> > I prefer to see the incremental patches once a patch has had review or
> > testing, so we can see which bits changed.  But if Greg intends to
> > merge this driver then he'd probably prefer a fresh new patch,
> > particularly as a) version 1 was only sent yesterday and b) he hasn't
> > merged version #1.
> 
> I do intend to merge it, given that it's in a buildable format :)

The point was that it's not buildable without linux-next queue
(mainly few patches from the powerpc-next git tree). So if you
apply it onto the pure linux-usb tree it won't build. Though it
will build in the -mm tree, as -mm bases on the linux-next.

That's exactly why I asked Andrew to merge it into the -mm tree
in the first place -- he would resend it to you at appropriate
time.


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
