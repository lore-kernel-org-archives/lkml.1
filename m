Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZDWQrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZDWQrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZDWQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:47:21 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:21519 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbZDWQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:47:19 -0400
Subject: Re: linux-next: upstream tree build warnings
From: Alex Williamson <alex.williamson@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <20090423225108.600a6e8e.sfr@canb.auug.org.au>
References: <20090423163847.200f227e.sfr@canb.auug.org.au>
	 <20090423.002403.74400050.davem@davemloft.net>
	 <20090423215533.157df0e0.sfr@canb.auug.org.au>
	 <20090423225108.600a6e8e.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: HP OSLO R&D
Date: Thu, 23 Apr 2009 10:46:37 -0600
Message-Id: <1240505197.9646.517.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 22:51 +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Thu, 23 Apr 2009 21:55:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > The callers came in throught commit
> > 0bde95690d65653e420d04856c5d5783155c747c ("virtio_net: Add support for
> > VLAN filtering in the hypervisor") which I assume came in throught the
> > net tree (it has you SOB on it). Committed Feb 5, 2009, went into Linus'
> > tree before 2.6.30-rc1.
> > 
> > scatterlist.h hasn't changed since July, 2008.
> 
> In other words, I think the bug has always been there and just never hit
> (yet).

Hmm, I can't seem to get the warning on an x86_64 allyesconfig build
with gcc-4.4.0.  Did all the archs other than powerpc miss this warning?
Thanks,

Alex


