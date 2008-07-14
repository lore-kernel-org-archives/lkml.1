Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYGNNeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYGNNeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYGNNd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:33:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYGNNd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:33:57 -0400
Date: Mon, 14 Jul 2008 09:32:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080714133221.GC16673@redhat.com>
References: <1215401122.4660.4.camel@caritas-dev.intel.com> <20080708145051.GA14745@redhat.com> <20080711122131.b6461ab1.akpm@linux-foundation.org> <20080711201149.GB3298@redhat.com> <1215824537.7319.7.camel@nigel-laptop> <20080714054644.GC20258@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714054644.GC20258@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 07:46:44AM +0200, Pavel Machek wrote:
> On Sat 2008-07-12 11:02:17, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Fri, 2008-07-11 at 16:11 -0400, Vivek Goyal wrote:
> > > Hi Andrew,
> > > 
> > > We can use this patchset for hibernation, but can it be a better way of doing
> > > things than what we already have, I don't know. Last time I had raised
> > > this question and power people had various views. In the end, Pavel wanted
> > > this patchset to be in.  Pavel, can tell more here...
> > > 
> > > To me this patchset looks interesting for couple of reasons.
> > > 
> > > - Looks like an interesting feature where one can have a separate kernel
> > >   in memory and one can switch between the kernels on the fly. It can
> > >   be modified to have more than one kernel in memory at a time.
> > 
> > I'm not sure how useful that would be, though. I already have
> > functionality in TuxOnIce which allows you to resume a different image
> > instead of powering off (roughly the same thing when combined with not
> > removing the image after resuming). It was neat when testing to be
> > able
> 
> Beaty of kjump is that it is supposed to used on half-broken system,
> so it is useful for debugging.
> 

What do you mean by supposed to be used on half-broken system?

Thanks
Vivek
