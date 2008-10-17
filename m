Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYJQLQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYJQLQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYJQLP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:15:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:10554 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYJQLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uNjli/wlWnHKNJv/CpcuFgW6qlXfc/9YGJphzhe9kqGCY6GtHi0D+rj+4857rakPrG
         lQAR1Zk3y4jaWuZcwFDAiB0+IuZLMPAWTMMGezoCqVqIqmK5lECGXVE85hbzkX5S9cKK
         TCKPFwzpn6/u+jSwHtL6eDZMsHTS0C9UEaHc0=
Date: Fri, 17 Oct 2008 15:18:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017111857.GB18284@x200.localdomain>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <1224237990.28131.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224237990.28131.84.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 12:06:30PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-10-17 at 11:56 +0300, Adrian Bunk wrote:
> > On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> > > On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
> > >...
> > > > Packages are built in a chroot with the correct release installed.
> > > 
> > > Then why would this break if they are being built against the correct,
> > > older, kernel?
> > 
> > How could you build userspace "against a kernel"?
> > 
> > sys_*uname() returns the version of the running kernel.
> 
> We have a uts namespace, you can make the thing return whatever well you
> please.

Hostname, domainname, what else?
