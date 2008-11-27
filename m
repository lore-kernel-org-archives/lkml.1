Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYK0NDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYK0NDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYK0NDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:03:07 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:54930 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYK0NDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:03:06 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 2/2] tracing: identify which executable object the
 userspace address belongs to
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20081127124851.GC23480@redhat.com>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
	 <1227353328-16104-3-git-send-email-edwintorok@gmail.com>
	 <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins>
	 <20081127124851.GC23480@redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 14:02:56 +0100
Message-Id: <1227790976.4454.1559.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 07:48 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Nov 27, 2008 at 11:41:45AM +0100, Peter Zijlstra wrote:
> > > > Impact: modify+improve the userstacktrace tracing visualization feature
> > > > [...]
> > > > You'll see stack entries like:
> > > >    /lib/libpthread-2.7.so[+0xd370]
> > > > [...]
> > > 
> > > Can you suggest an actual distribution & architecture where this
> > > facility may be tested/used?  It appears to require frame-pointer
> > > stuff that AFAIK is not generally turned on for user-space.
> > 
> > gentoo, just rebuild world with frame pointers ;-)
> 
> Well, that only goes so far.  If this feature turns out unable to work
> without distributors recompiling all their stuff on, for example, x86-64,
> then expectations need to be reset.

Who says you need a distributor to recompile stuff.. there are plenty
people running gentoo, and it doesn't take all that long to rebuild
world on these multi-socket quad core boxen we have today ;-)

Although with gcc getting ever slower and desktop software ever more
bloated who knows,.. but then its your own fault if you install gnome
and such, gentoo comes lean and mean from the stage3 cage.

I wish more distros would be as easy to rebuild as gentoo is, its a real
feature.

