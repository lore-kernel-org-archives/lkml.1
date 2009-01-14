Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbZANADZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbZANADZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZANACw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:02:52 -0500
Received: from kroah.org ([198.145.64.141]:41720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756628AbZANACv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:02:51 -0500
Date: Tue, 13 Jan 2009 16:01:30 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090114000130.GA20811@kroah.com>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <20090113233932.GA18000@kroah.com> <20090113234734.GA32190@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113234734.GA32190@ioremap.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:47:34AM +0300, Evgeniy Polyakov wrote:
> On Tue, Jan 13, 2009 at 03:39:32PM -0800, Greg KH (greg@kroah.com) wrote:
> > On Wed, Jan 14, 2009 at 02:05:26AM +0300, Evgeniy Polyakov wrote:
> > > Patches were split on per-file basis, so tree in the middle of the series will not
> > > compile, which should not be a problem, since kconfig/makefile changes are introduced
> > > in the latest patch.
> > 
> > Looks good to me, but do we need the "export these symbols" patch to get
> > this to work properly as well?
> 
> No, exports are needed for POHMELFS which I'm waiting a reply from
> Andrew or Linus.

Ah, sorry, got the two confused :)

> > Also, can you send me a patch with a TODO file in the
> > drivers/staging/dst/ directory, detailing what needs to be done on it to
> > move it over to the main portion of the kernel?
> 
> Nothing :)

Great!

> Really. I implemented all the suggestions I got from the previous
> reviews (including spaces and documentations, which btw were the only
> ones :) way too long ago and did not get any other complaints. Actually
> the tree I sent to you does not contain documentation update I have in
> the own tree (pointed during review), so this can be added as todo entry :)
> My fault I found that too late.

Hm, then why can't this whole thing just go into fs/dst/ right now?
It's self-contained, so there shouldn't be any special "must live in
staging" rule for filesystems before adding them.

We take new drivers at almost any point in the release cycle, why should
filesystems be any different?

Linus, Andrew, any objections?

thanks,

greg k-h
