Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYKZAEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYKZAEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYKZAE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:04:27 -0500
Received: from kroah.org ([198.145.64.141]:33194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbYKZAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:04:27 -0500
Date: Tue, 25 Nov 2008 16:03:40 -0800
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <ijc@hellion.org.uk>,
       Daniel =?iso-8859-1?Q?Schr=F6der?= <mail@dschroeder.info>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Change 5c371b31be3203 in stable breaks Xen
Message-ID: <20081126000340.GB1091@kroah.com>
References: <492C6D8D.3040600@goop.org> <1227654364.27529.3.camel@localhost.localdomain> <492C897E.1010509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492C897E.1010509@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 03:25:50PM -0800, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > On Tue, 2008-11-25 at 13:26 -0800, Jeremy Fitzhardinge wrote:
> >   
> >> I have a report of Xen breaking between 2.6.27.5 and .6.  I bisected
> >> it 
> >> down to change:
> >>
> >> commit 5c371b31be32033b0a4a993431484da8a2305369
> >> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> >> Date:   Mon Sep 22 02:52:26 2008 -0700
> >>
> >>     x86: fix CONFIG_X86_RESERVE_LOW_64K=y
> >>    
> >>     commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439 upstream
> >>     
> >
> > Looks like 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7 might be needed in
> > stable too?
> >   
> 
> Ah, yes, that looks like the right fix.  I'll see if it helps.

If so, let us know and we will add it to the next -stable release.

thanks,

greg k-h
