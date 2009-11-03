Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZKCKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZKCKCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZKCKCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:02:30 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55511 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZKCKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:02:29 -0500
Date: Tue, 3 Nov 2009 11:02:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] Use unified UUID/GUID definition in gfs2
Message-ID: <20091103100232.GA489@merkur.ravnborg.org>
References: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com> <20091101093545.a7a4693a.akpm@linux-foundation.org> <1257123583.30470.1161.camel@yhuang-dev.sh.intel.com> <20091102150221.948d8427.akpm@linux-foundation.org> <1257209088.30470.1171.camel@yhuang-dev.sh.intel.com> <20091102170249.d1bf0aea.akpm@linux-foundation.org> <1257232919.22519.40.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257232919.22519.40.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 03:21:59PM +0800, Huang Ying wrote:
> On Tue, 2009-11-03 at 09:02 +0800, Andrew Morton wrote: 
> > On Tue, 03 Nov 2009 08:44:48 +0800
> > Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > For stuff of no use to user space, I think it can be enclosed into
> > > 
> > > #ifdef __KERNEL__
> > > #endif
> > 
> > It can, but that's ugly.  Clearly separating the inclusions into uuid-kernel.h
> > and uuid-user-h is nicer, no?
> 
> But it seems that __KERNEL__ is common used method now. There are about
> 370 out of 3085 files under linux/include use __KERNEL__.

Just because we were sloopy in the past is no excuse for repeating this.

	Sam
