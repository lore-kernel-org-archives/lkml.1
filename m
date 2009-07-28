Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZG1WCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZG1WCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZG1WCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:02:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:44184 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZG1WCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:02:22 -0400
Date: Tue, 28 Jul 2009 18:02:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728220203.GI31679@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk> <20090728195648.GA4833@kroah.com> <20090728204720.GF31679@mit.edu> <20090728210121.GB12155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728210121.GB12155@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 02:01:21PM -0700, Greg KH wrote:
> On Tue, Jul 28, 2009 at 04:47:20PM -0400, Theodore Tso wrote:
> > On Tue, Jul 28, 2009 at 12:56:48PM -0700, Greg KH wrote:
> > > 
> > > Do you have a pointer to your previous queue before you zapped it so
> > > that others might be able to pick it up?
> > > 
> > 
> > It's also available from linux-next as commit:
> > 
> >      024ea7873598686f3e02002ca23c2e8fa3fddd30
> 
> Hm, that's the wrong end of the tree, I think you mean
> fbfa97a856a4ce2fa86058cff84f589eb7f1364e, right?

It all depends on your point of view, I guess.  The "last" commit in
the branch is 024ea78, so you can see the whole queue if you use the
command "git log 024ea78"; hence, it's the most useful if you're
trying to find the patch series via git.

The whole set of tty patches can be found via:

git log e00b95d..024ea78

(where e00b95d is the parent of fbfa978).

       	       	  					- Ted
