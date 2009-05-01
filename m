Return-Path: <linux-kernel-owner+w=401wt.eu-S1765743AbZEAUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765743AbZEAUeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764746AbZEAUeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:34:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764298AbZEAUeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:34:23 -0400
Date: Fri, 1 May 2009 13:28:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mpm@selenic.com, clameter@sgi.com, mingo@elte.hu,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] use GFP_NOFS in kernel_event()
Message-Id: <20090501132818.b16704c4.akpm@linux-foundation.org>
In-Reply-To: <1241201494.3086.3.camel@dhcp231-142.rdu.redhat.com>
References: <20090430020004.GA1898@localhost>
	<20090429191044.b6fceae2.akpm@linux-foundation.org>
	<1241097573.6020.7.camel@localhost.localdomain>
	<20090430141041.c167b4d4.akpm@linux-foundation.org>
	<1241201494.3086.3.camel@dhcp231-142.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 May 2009 14:11:34 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Thu, 2009-04-30 at 14:10 -0700, Andrew Morton wrote:
> > On Thu, 30 Apr 2009 09:19:33 -0400
> > Eric Paris <eparis@redhat.com> wrote:
> > 
> > > > Somebody was going to fix this for us via lockdep annotation.
> > > > 
> > > > <adds randomly-chosen cc>
> > > 
> > > I really didn't forget this, but I can't figure out how to recreate it,
> > > so I don't know if my logic in the patch is sound.  The patch certainly
> > > will shut up the complaint.
> > 
> > Do you think we should merge the GFP_NOFS workaround for 2.6.30 and
> > fix all up nicely for 2.6.31?
> 
> I'm all for it for 2.6.30

OK.

> although the patch really should have been
> the one that gets the audit use case too at 
> 
> >From me on Mar 18 Subject [PATCH] make inotify event handles use
> GFP_NOFS
> 
> http://lkml.org/lkml/2009/3/18/310

I queued that as an incremental to Wu Fengguang's patch, because
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch
has a longer changelog ;)

