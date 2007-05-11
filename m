Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbXEKVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbXEKVSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbXEKVSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:18:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45146 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934232AbXEKVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:18:22 -0400
Date: Fri, 11 May 2007 23:18:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, rpjday@mindspring.com, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070511211823.GG7984@stusta.de>
References: <4643BDF2.9030105@gmail.com> <20070511114605.4c2698ec@the-village.bc.nu> <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 07:42:38AM -0400, John Anthony Kazos Jr. wrote:
> > > The email address is the problem I was trying to fix; with multiple current 
> > > and non-current authors and maintainers who might not even be authors the 
> > > address(es) available from the tag confuse the issue of whom to contact. 
> > > It's moreover also information that easily outdated.
> > > 
> > > A bit more than half of the tags in the tree don't include an email address 
> > > already and I'll submit patches removing more...
> > 
> > Please don't do this
> > 
> > NACK this change.
> > 
> > Whether someone puts their email address into the entry is their own
> > business. We do not need a style police for module author entries.
> > 
> > At most you might want to put
> > 
> > 	"If you include an email address then please use an address that
> > 	 you expect to keep for the long term, and if you change address
> > 	 please remember to update or remove the entry"
> > 
> > > A bit more than half of the tags in the tree don't include an email 
> > > address already and I'll submit patches removing more...
> > 
> > And I'll NAK every one which hasn't been signed off by the email address
> > listed OR the address bounces. In which case removing it is good.
> 
> Can't we just subtitle it somehow? Add tags: " (current maintainer)",
> " (original author, inactive)", " (bug and defect reports)", or whatever 
> you like after the names.

This still wouldn't solve the following problems:
- I doubt it will be kept up to date for all > 2800 modules in the kernel
- the 3 year old kernel of your distribution would contain 3 year old
  maintainership information
- maintainers sometimes disappear

The default for "bug and defect reports" should be for all modules (as 
well as for non-modular code) from ftp.kernel.org kernels either 
linux-kernel or the kernel Bugzilla. [1]

For distribution kernels (which are what most users are using), the
default for "bug and defect reports" should be the distribution support.

cu
Adrian

[1] contacting the maintainer directly is often better, but there's no 
    sane way to put this information into the kernel binary

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

