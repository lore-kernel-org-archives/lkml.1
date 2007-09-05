Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbXIEQ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbXIEQ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbXIEQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:28:15 -0400
Received: from pat.uio.no ([129.240.10.15]:50466 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbXIEQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:28:14 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <1188996257.3119.7.camel@raven.themaw.net>
References: <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188577275.6649.133.camel@heimdal.trondhjem.org>
	 <5813.1188892468@redhat.com>  <1188996257.3119.7.camel@raven.themaw.net>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 17:26:32 +0100
Message-Id: <1189009592.13235.37.camel@gaula.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: AED06AA464E6DDB9E8B572D5F7DE7BC305878325
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 435 total 3690025 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 20:44 +0800, Ian Kent wrote:
> On Tue, 2007-09-04 at 08:54 +0100, David Howells wrote:
> > Bill Davidsen <davidsen@tmr.com> wrote:
> > 
> > > mount /base on point1 - rw	[ hopefully really r/w ]
> > > mount /base on point2 - ro	[ hopefully r/o ]
> > 
> > I think Al Viro probably has the right idea as to how to fix this: Move the
> > R/O R/W flag into vfsmount and count the number of R/W vfsmounts in the
> > superblock.  I never quite finished implementing the patch to do this, but I
> > can go back and revisit it.
> 
> But what about mounting with different protocol, tcp vs udp for example.
> 
> Ian

With the patch that Linus merged, we will fork off a new superblock.

Trond

