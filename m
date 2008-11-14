Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYKNRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYKNRog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKNRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:44:25 -0500
Received: from kroah.org ([198.145.64.141]:44766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751810AbYKNRoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:44:24 -0500
Date: Fri, 14 Nov 2008 09:32:58 -0800
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you add the staging tree to -next?
Message-ID: <20081114173258.GC22980@kroah.com>
References: <20081112235600.GA27554@kroah.com> <Pine.LNX.4.64.0811140825410.11953@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811140825410.11953@anakin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 08:42:48AM +0100, Geert Uytterhoeven wrote:
> On Wed, 12 Nov 2008, Greg KH wrote:
> > I'm starting to get people sending me patches against -next for the
> > drivers/staging/ tree that don't apply as -next does not include my
> > quilt tree of staging patches.
> > 
> > Can you please pick it up?  You can put it at the end of your series,
> > and the 'make allmodconfig' option disables building anything in the
> > drivers/staging/ subdirectory, so it should not have any build or merge
> > conflicts with anything.
> 
> Apart from the patches you receive against -next, is there any other
> advantage, giving staging is disabled?

That is a huge advantage, don't discount it.  My staging tree has over
150 patches in it right now, and is quite diverged from what is in
Linus's tree.  I have been getting the same patches sent over and over
to fix the same thing that is already resolved in my tree, as the
developers are working against -next thinking that they were working
with the latest development tree.

This will save a lot of redundant developer time, a good thing.

It also lets me test -next with -staging in it so I can anticipate the
merge issues that will be happening in the next big merge (v4l is going
to have issues that I've noticed already.)

thanks,

greg k-h
