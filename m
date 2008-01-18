Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYARLdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYARLdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYARLdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:33:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYARLdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YQw90lZuKZkPeLFv1rgLoTVQg+wb6zRUDZTVg/m7HikahMGAvGKQZJeTkd003yiP6lFXF0hBHswtPCy8LFcSZFhY65PBEFx0/AYI62cFPP1Xs3/aZr3AxfHAdap9a8CmPY00QaoRQRD/R7bcajOEfOury5ptnvbzogbuZYRenho=
Date: Fri, 18 Jan 2008 12:40:01 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080118114001.GA2610@ff.dom.local>
References: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117203155.GA2791@ami.dom.local> <20080117232626.GC2905@ami.dom.local> <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com> <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com> <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site> <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <1200653112.8706.21.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200653112.8706.21.camel@lov.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 11:45:12AM +0100, Kay Sievers wrote:
> On Fri, 2008-01-18 at 08:38 +0100, Jarek Poplawski wrote:
> > On Fri, Jan 18, 2008 at 01:31:17PM +0800, Dave Young wrote:
> > > On Jan 18, 2008 11:18 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > ...
> > > > Yeah, might be better to wait until class_device is gone, otherwise you
> > > > may need to fix stuff that is just going to be removed. Your change to
> > > > have iterators for the class devices look like a nice preparation for
> > > > future changes though.
> > > >
> > > > Our rough plan is:
> > > >  2.6.25:
> > > >   - get the ~100 patches in Greg's tree (in -mm) merged :)
> > > >  2.6.26:
> > > > ???  - remove the 20 char limit in "struct device"
> > > >   - get rid of "struct class_device"
> > > 
> > > Fine, thanks.
> > > 
> > > Let's wait for other people's comment.
> > 
> > Dave, I doubt you'll ever manage to do this if you're going to wait:
> > probably there will be always some new changes like this around...
> 
> Well there are not "changes" in that sense, the class_device stuff will
> be entirely ripped out, and I doubt we will want to change anything
> there, just shortly before it's deleted.

So, 2.6.26 means shortly... And this all needs some time for testing,
debugging or maybe some change of concept, so this would take a while...
Well, it's not my problem, but since this stuff will go away, shouldn't
we care more about the staff that will stay?

> Also your assumptions about device nesting are not really true, there is
> no limit, even when there are no current users nesting deeper, and
> "struct device" can be any nesting depth, and that's where it gets
> interesting.

I'm just trying to figure this out. It seems this is a real problem
while freezing, but not necessarily here (but I can miss something).
 
Regards,
Jarek P.
