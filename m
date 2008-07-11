Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbYGKUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbYGKUYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYGKUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:24:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40376 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYGKUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:24:05 -0400
Date: Fri, 11 Jul 2008 22:24:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080711202434.GB6261@elf.ucw.cz>
References: <1215401122.4660.4.camel@caritas-dev.intel.com> <20080708145051.GA14745@redhat.com> <20080711122131.b6461ab1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711122131.b6461ab1.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-11 12:21:31, Andrew Morton wrote:
> On Tue, 8 Jul 2008 10:50:51 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
> > > This patch provides an enhancement to kexec/kdump. It implements
> > > the following features:
> > > 
> > > - Backup/restore memory used by the original kernel before/after
> > >   kexec.
> > > 
> > > - Save/restore CPU state before/after kexec.
> > > 
> > 
> > Hi Huang,
> > 
> > In general this patch set looks good enough to live in -mm and
> > get some testing going.
> > 
> > To me, adding capability to return back to original kernel looks
> > like a logical extension to kexec functionality.
> 
> Exciting ;)  It's much less code than I expected.
> 
> I don't think I understand the feature any more.  Once upon a time we
> thought that this might become a new and better (or at least
> better-code-sharing) way of doing suspend-to-disk.  How far are we from
> that?

Well, it will be tricky to get kjump-hibernation right with respect to
ACPI, but we should be fairly close to basic hibernation working with
this. It has major advantage of not needing refrigerator (and few
disadvantages -- like doing aditional boot during suspend).

But main reason I'd like kjump to be in is different -- it should be
useful to stuff like "dump but continue running", etc...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
