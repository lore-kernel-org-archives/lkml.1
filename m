Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYAFM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYAFM7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYAFM7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:59:22 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57413 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYAFM7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:59:21 -0500
Date: Sun, 6 Jan 2008 14:58:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106125849.GE2082@does.not.exist>
References: <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780BBAA.7020908@s5r6.in-berlin.de> <20080106115941.GB2082@does.not.exist> <4780CA63.50703@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4780CA63.50703@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:32:35PM +0100, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sun, Jan 06, 2008 at 12:29:46PM +0100, Stefan Richter wrote:
> >> Adrian Bunk wrote:
> >>> Duplicating the structure in each UI should be an improvement?
> >>>
> >>> Hardly.
> >> What do you mean?
> ...
> > You said:
> > "The graphic UIs including menuconfig currently work best for tree-like 
> >  dependencies"
> > 
> > That's true.
> > 
> > And the dependency graph can't be a tree.
> > 
> > Currently, defining the ordered tree the UIs present to the user is done 
> > _once_ in kconfig.
> > 
> > Our UIs either show this tree as a tree or go through the tree 
> > depth-first and present the options in this order to the user.
> 
> All correct.
> 
> > And I think your main misunderstanding is that you think the 
> > dependencies alone would carry enough information for allowing an UI to 
> > present the options in a way not worse than it's currently done - that's 
> > simply not true.
> 
> No, the dependency relationships alone do not carry enough information.
>   I am aware of that.
> 
> For example, we certainly want groupings or tags such as "option is
> (directly) related to USB hardware", "filesystems related option",
> "option is for debugging purposes" etc..  We currently provide hints
> like this via the 'menu' keyword.  We also want help texts per option
> and per group of options.
> 
> However, there is ultimately not a single most logical way to group
> options.  There could be groups which would overlap.  The grouping per
> 'menu' provides only one fixed non-overlapping grouping.

I don't think your implementation would result in a better UI.

But I know that have a tendency of being overly pessimistic and ideas I 
didn't like often turn out to be good, so feel free to prove me wrong.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

