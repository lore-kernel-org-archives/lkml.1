Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbXGJR1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbXGJR1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXGJR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:27:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437AbXGJR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:27:41 -0400
Date: Tue, 10 Jul 2007 10:27:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-Id: <20070710102716.2fcae91c.akpm@linux-foundation.org>
In-Reply-To: <20070710154503.GC27033@thunk.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
	<20070710022213.81e7b432.akpm@linux-foundation.org>
	<20070710154503.GC27033@thunk.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:45:03 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Jul 10, 2007 at 02:22:13AM -0700, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 11:07:37 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > We reserved a different syscall number than the one that is used right now
> > > in the patch. Please drop this patch... Martin or I will wire up the syscall
> > > as soon as the x86 variant is merged. Everything else just causes trouble and
> > > confusion.
> > 
> > OK, I dropped all the fallocate patches.
> 
> Andrew, I want to clarify who is going to push the fallocate patches.
> I can either push them to Linus as part of the ext4 patch set, or we
> can wait for you to push them.  I thought since you had them in -mm
> and we were going to wait you to push them (and presume that this was
> going to happen soon).

How about you send them?  The syscall numbers might need to be changed
based upon when/whether the revoke patches get merged.

> Alternatively I can push them directly to Linus along with other ext4
> patches.

I note that nobody really bothered reviewing all those ext4 patches.

Do you feel that they have been adequately reviewed?  I don't.  I guess I
know what I'll be doing today :(

>  We can drop the s390 patch if Martin or Heiko wants to wire
> it up themselves.

ia64 needs changing too.

