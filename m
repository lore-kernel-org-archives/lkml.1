Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYAFMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYAFMA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYAFMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:00:15 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47054 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYAFMAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:00:13 -0500
Date: Sun, 6 Jan 2008 13:59:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106115941.GB2082@does.not.exist>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780BBAA.7020908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4780BBAA.7020908@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 12:29:46PM +0100, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sun, Jan 06, 2008 at 01:35:21AM +0100, Stefan Richter wrote:
> >> instead work on better UIs if you have got
> >> trouble with the complexities of the dependencies graph.  The graphic
> >> UIs including menuconfig currently work best for tree-like dependencies,
> >> but the graph isn't a tree.  Think about how to present this properly in
> >> an UI.  The Kconfig files are the wrong place to attack this problem.
> >> ...
> > 
> > Duplicating the structure in each UI should be an improvement?
> > 
> > Hardly.
> 
> What do you mean?
> 
> We have dependency data in the Kconfig files.  We have a few different
> UIs to them.  Why there are different UIs is easy (oldconfig vs.
> xconfig) or not so easy (gconfig vs. xconfig) to explain.  Anyway; IMO
> we should keep data and presentation separate for at least two reasons:
>   - to allow us to have specialized task-oriented UIs (oldconfig,
>     randconfig et cetera)
>   - because different people have different approaches to kernel
>     configuration (the guy who sets up a new box vs. the guy who bought
>     a new gadget vs. the guy who updates his kernel vs. the control
>     freak vs. the kernel tester vs...)
>...

You said:
"The graphic UIs including menuconfig currently work best for tree-like 
 dependencies"

That's true.

And the dependency graph can't be a tree.

Currently, defining the ordered tree the UIs present to the user is done 
_once_ in kconfig.

Our UIs either show this tree as a tree or go through the tree 
depth-first and present the options in this order to the user.

And I think your main misunderstanding is that you think the 
dependencies alone would carry enough information for allowing an UI to 
present the options in a way not worse than it's currently done - that's 
simply not true.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

