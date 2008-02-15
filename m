Return-Path: <linux-kernel-owner+w=401wt.eu-S935047AbYBOW5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbYBOW5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765519AbYBOWqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:46:40 -0500
Received: from xenotime.net ([66.160.160.81]:39060 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764551AbYBOWqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:46:38 -0500
Date: Fri, 15 Feb 2008 14:46:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel-doc : possible fix for non-fatal perl errors when
 parsing some function pointers
Message-Id: <20080215144636.aeef1837.rdunlap@xenotime.net>
In-Reply-To: <1203097344.2929.63.camel@castor.localdomain>
References: <1203095592.2929.54.camel@castor.localdomain>
	<20080215092154.4a8cbba7.rdunlap@xenotime.net>
	<1203097344.2929.63.camel@castor.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 17:42:24 +0000 Richard Kennedy wrote:

> 
> On Fri, 2008-02-15 at 09:21 -0800, Randy Dunlap wrote:
> > On Fri, 15 Feb 2008 17:13:12 +0000 Richard Kennedy wrote:
> > 
> > > When running "make htmldocs" I'm seeing some non-fatal perl errors
> > > caused by trying to parse the callback function definitions in
> > > blk-core.c.
> > > 
> > >
> > 
> > Hi Richard,
> > Thanks for the patch.  I was planning to look into this problem
> > this weekend.
> > 
> > I think that changing scripts/kernel-doc to accept the current
> > kernel source tree usage is the right thing to do, even if the
> > block/blk code is a bit different.  I'll test it a bit and then
> > push it.
> > 
> > I appreciate the patch.
> > 
> No problem. 
> 
> I have given the patch some testing, and the output xml is the same
> except for the blk_end_request_callback entry.
> 
> But I wonder if it should change to this :-
> 
> > -         $type =~ s/([^\(]+\(\*)$param/$1/;
> > +         $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
> 
> just in case there is some stray whitespace in there.

That should be OK, so I changed that line.

Can I get a Signed-off-by: from you, please?

Thanks,
---
~Randy
