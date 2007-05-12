Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbXELHPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbXELHPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXELHO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:14:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45311 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757266AbXELHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:14:55 -0400
Date: Sat, 12 May 2007 09:14:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, rpjday@mindspring.com, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070512071455.GH7984@stusta.de>
References: <4643BDF2.9030105@gmail.com> <20070511114605.4c2698ec@the-village.bc.nu> <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com> <20070511211823.GG7984@stusta.de> <20070511223500.01fe6596@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070511223500.01fe6596@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 10:35:00PM +0100, Alan Cox wrote:
> > This still wouldn't solve the following problems:
> > - I doubt it will be kept up to date for all > 2800 modules in the kernel
> > - the 3 year old kernel of your distribution would contain 3 year old
> >   maintainership information
> > - maintainers sometimes disappear
> 
> Maintainers sometimes DON'T disappear ....

No disagreement about that.

But things like disappearing maintainers, unmaintained code, and 
maintainership that is at most informal (e.g. currently the floppy 
driver) are real-life problems that do occur in several cases.

> > The default for "bug and defect reports" should be for all modules (as 
> > well as for non-modular code) from ftp.kernel.org kernels either 
> > linux-kernel or the kernel Bugzilla. [1]
> 
> If users put it in the kernel bugzilla its gets lost because most of the
> bugzilla isn't set up to route bugs to maintainers. In the unlikely event

Bugzilla is actually setup to route bugs of the maintainer, this is 
currently implemented through the Bugzilla feature "Andrew"...

> it arrives there or it gets posted to linux-kernel the only reply is
> "report it to your distributor"
> 
> > For distribution kernels (which are what most users are using), the
> > default for "bug and defect reports" should be the distribution support.
> 
> I'd prefer not. I get reports from people about drivers that got "lost"
> by vendors, regularly. Nor am I pointing fingers at specific vendors here,
> last month I sorted out a two year old "lost in Red Hat Bugzilla" kernel
> bug for example.

How many maintainers want to get bug reports against the kernel 2.6.9 
shipped with RHEL 4?

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

