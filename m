Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXIEMod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXIEMod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXIEMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:44:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46439 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbXIEMoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:44:25 -0400
X-Sasl-enc: YtJvNnN3OQQAB8IaRz8OUUb1HgzbfuEp8tGp8O9ur1nh 1188996263
Subject: Re: recent nfs change causes autofs regression
From: Ian Kent <raven@themaw.net>
To: David Howells <dhowells@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <5813.1188892468@redhat.com>
References: <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <5813.1188892468@redhat.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 20:44:17 +0800
Message-Id: <1188996257.3119.7.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 08:54 +0100, David Howells wrote:
> Bill Davidsen <davidsen@tmr.com> wrote:
> 
> > mount /base on point1 - rw	[ hopefully really r/w ]
> > mount /base on point2 - ro	[ hopefully r/o ]
> 
> I think Al Viro probably has the right idea as to how to fix this: Move the
> R/O R/W flag into vfsmount and count the number of R/W vfsmounts in the
> superblock.  I never quite finished implementing the patch to do this, but I
> can go back and revisit it.

But what about mounting with different protocol, tcp vs udp for example.

Ian


