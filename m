Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbXGJUqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbXGJUqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXGJUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:46:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47602 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbXGJUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:46:06 -0400
Date: Wed, 11 Jul 2007 01:58:34 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070710202834.GH8797@amitarora.in.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org> <20070710154503.GC27033@thunk.org> <20070710182047.GJ15463@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710182047.GJ15463@ca-server1.us.oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:20:47AM -0700, Mark Fasheh wrote:
> On Tue, Jul 10, 2007 at 11:45:03AM -0400, Theodore Tso wrote:
> > On Tue, Jul 10, 2007 at 02:22:13AM -0700, Andrew Morton wrote:
> > > On Tue, 10 Jul 2007 11:07:37 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > > We reserved a different syscall number than the one that is used right now
> > > > in the patch. Please drop this patch... Martin or I will wire up the syscall
> > > > as soon as the x86 variant is merged. Everything else just causes trouble and
> > > > confusion.
> > > 
> > > OK, I dropped all the fallocate patches.
> > 
> > Andrew, I want to clarify who is going to push the fallocate patches.
> > I can either push them to Linus as part of the ext4 patch set, or we
> > can wait for you to push them.  I thought since you had them in -mm
> > and we were going to wait you to push them (and presume that this was
> > going to happen soon).
> > 
> > Alternatively I can push them directly to Linus along with other ext4
> > patches.  We can drop the s390 patch if Martin or Heiko wants to wire
> > it up themselves.
> > 
> > As far as I know there hasn't been any real contention on the actual
> > syscall patches, other than the numbering issues, so it seems that
> > pushing them to Linus sooner rather than later is the right thing to
> > do. 
> 
> Where is the latest and greatest version of those patches? Is it still the
> patch set distributed in 2.6.22-rc6-mm1? I'd mostly like to see the final
> set of flags we're planning on supporting. But yeah, I second the "sooner
> rather than later" :)

I have posted the latest fallocate patches as part of TAKE6. These
patches are exactly same as how they currently look in the ext4 patch
queue being maintained by Ted.

--
Regards,
Amit Arora
