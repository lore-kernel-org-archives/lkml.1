Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJQKGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJQKGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYJQKGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:06:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYJQKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:06:39 -0400
Subject: Re: [RFC] Kernel version numbering scheme change
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081017085604.GA20986@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com>
	 <20081016124943.GE23630@cs181140183.pp.htv.fi>
	 <20081016151748.GA31075@kroah.com>
	 <20081016164602.GA22554@cs181140183.pp.htv.fi>
	 <20081017034717.GA28188@kroah.com>
	 <20081017064751.GE22554@cs181140183.pp.htv.fi>
	 <20081017075544.GB4850@kroah.com>
	 <20081017085604.GA20986@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 12:06:30 +0200
Message-Id: <1224237990.28131.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 11:56 +0300, Adrian Bunk wrote:
> On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
> >...
> > > Packages are built in a chroot with the correct release installed.
> > 
> > Then why would this break if they are being built against the correct,
> > older, kernel?
> 
> How could you build userspace "against a kernel"?
> 
> sys_*uname() returns the version of the running kernel.

We have a uts namespace, you can make the thing return whatever well you
please.



