Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYK0Mtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYK0Mtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYK0Mtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:49:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYK0Mtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:49:32 -0500
Date: Thu, 27 Nov 2008 07:48:51 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace address belongs to
Message-ID: <20081127124851.GC23480@redhat.com>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227782505.4454.1393.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Nov 27, 2008 at 11:41:45AM +0100, Peter Zijlstra wrote:
> > > Impact: modify+improve the userstacktrace tracing visualization feature
> > > [...]
> > > You'll see stack entries like:
> > >    /lib/libpthread-2.7.so[+0xd370]
> > > [...]
> > 
> > Can you suggest an actual distribution & architecture where this
> > facility may be tested/used?  It appears to require frame-pointer
> > stuff that AFAIK is not generally turned on for user-space.
> 
> gentoo, just rebuild world with frame pointers ;-)

Well, that only goes so far.  If this feature turns out unable to work
without distributors recompiling all their stuff on, for example, x86-64,
then expectations need to be reset.


- FChE
