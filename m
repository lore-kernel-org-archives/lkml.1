Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbXI1Rb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbXI1Rb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXI1RbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:31:20 -0400
Received: from phobos01.frii.com ([216.17.128.161]:53883 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbXI1RbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:31:20 -0400
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 13:31:20 EDT
From: "Elyse M. Grasso" <emgrasso@data-raptors.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Date: Fri, 28 Sep 2007 11:12:51 -0600
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au>
In-Reply-To: <200709281005.34001.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709281112.52844.emgrasso@data-raptors.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007, Nick Piggin wrote:
> On Saturday 29 September 2007 00:34, Linus Torvalds wrote:
> > On Fri, 28 Sep 2007, Nick Piggin wrote:
> > > > God I hate select.
> > >
> > > IMO a better implementation would result in a notification / 
confirmation
> > > of turning on new items, and the ability to deselect options which will
> > > also confirm to deselect dependants. Like most other systems that have
> > > similar problem to solve.
> >
> > Actually, the *really* nice thing to do would be to just add the reason
> > something got enabled into the ".config" file.
> >
> > IOW, wouldn't it be nice if the .config file just said
> >
> > 	...
> > 	CONFIG_ACPI=y		# selected by X86_64_ACPI_NUMA
> > 	CONFIG_ACPI_PROCFS=y	# user choice
> > 	...
> >
> > etc, since the config process actually does know these things?
> 
> Sure, that would probably be pretty trivial to implement too, and
> would solve most problems for kernel devs.
> 
> At a level up from that, I think ease of use could be improved with
> a package manager-type chained-selection/deselection feature in
> the config tools.
> 
> Not that I'm volunteering to implement either ;)
> 
> >
> > That way, there's always a fairly straightforward way to see why some
> > configuration is the way it is (and the .config file is not only useful
> > for "make oldconfig", it's also what normally gets passed around for bug
> > reports, and is part of distro kernel packages etc, so it would seem to be
> > the right place, no?)
> >
> > 		Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Adding the comments to the .config files sounds like a good project for a 
comparative newbie. By the end of next week I should have hardware available 
for experimental kernel builds. (And also some free wetware cycles.) 

Are there any other requirements for formatting I should consider? 

In a case where option A is specified by option B which is specified by option 
C which is specified by option D, should the comment on A mention B, or D or 
all three items in the chain? 

-- 
Elyse Grasso

http://www.data-raptors.com    Computers and Technology
http://www.astraltrading.com   Divination and Science Fiction
http://www.data-raptors.com/global-cgi-bin/cgiwrap/emgrasso/blosxom.cgi WebLog
