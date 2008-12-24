Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbYLXUUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbYLXUUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 15:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYLXUUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 15:20:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbYLXUUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 15:20:37 -0500
Date: Wed, 24 Dec 2008 12:18:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
 managing endpoint queues
Message-Id: <20081224121853.b46e9174.akpm@linux-foundation.org>
In-Reply-To: <20081224200845.GA1064@oksana.dev.rtsoft.ru>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
	<20081224191303.GA21815@oksana.dev.rtsoft.ru>
	<20081224195935.GA11531@kroah.com>
	<20081224200845.GA1064@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 23:08:45 +0300 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Wed, Dec 24, 2008 at 11:59:36AM -0800, Greg KH wrote:
> > On Wed, Dec 24, 2008 at 10:13:03PM +0300, Anton Vorontsov wrote:
> > > Follow these changes for the FHCI driver:
> > 
> > Hm, would it just make more sense to respin the whole driver?  That way
> > it's never in the tree in a "broken" state?
> 
> It's for -mm tree. If I understand -mm workflow correctly, Andrew
> will merge all the fixes into the final patch before sending it to
> you in late -rc0 phase, when various -next git trees (on which this
> driver depend) will be merged into the Linus tree.
>
> Andrew, am I correct?

Yes, that's what I do.

I prefer to see the incremental patches once a patch has had review or
testing, so we can see which bits changed.  But if Greg intends to
merge this driver then he'd probably prefer a fresh new patch,
particularly as a) version 1 was only sent yesterday and b) he hasn't
merged version #1.


