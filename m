Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYJQL3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYJQL3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJQL3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:29:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:16261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYJQL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AfJ32OmfsMzRFMeT2sa1s/n6Xitx8iVc6sV2tJynNtl7cTeH9gxnsyN6ZGGEqQA8mZ
         9/6PQsWR49tl7PZk7HyfKDx2TD/saTFPo/yH1/Zw5zv2DBavla6226AhJgvqb0sOIpvA
         aUvnREIqApXZh1MdidRLiqdMjaE0IUJZJK8fQ=
Date: Fri, 17 Oct 2008 15:32:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017113234.GC18284@x200.localdomain>
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <1224237990.28131.84.camel@twins> <20081017111857.GB18284@x200.localdomain> <1224242787.28131.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224242787.28131.97.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:26:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-10-17 at 15:18 +0400, Alexey Dobriyan wrote:
> > On Fri, Oct 17, 2008 at 12:06:30PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2008-10-17 at 11:56 +0300, Adrian Bunk wrote:
> > > > On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> > > > > On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
> > > > >...
> > > > > > Packages are built in a chroot with the correct release installed.
> > > > > 
> > > > > Then why would this break if they are being built against the correct,
> > > > > older, kernel?
> > > > 
> > > > How could you build userspace "against a kernel"?
> > > > 
> > > > sys_*uname() returns the version of the running kernel.
> > > 
> > > We have a uts namespace, you can make the thing return whatever well you
> > > please.
> > 
> > Hostname, domainname, what else?
> 
> Can't it fake the version number? - 

It can, but is there a system call for this?

> sounds like a useful feature :-)
