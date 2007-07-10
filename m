Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXGJSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXGJSm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbXGJSmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:42:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbXGJSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:42:33 -0400
Date: Tue, 10 Jul 2007 11:41:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-Id: <20070710114119.d8e874a1.akpm@linux-foundation.org>
In-Reply-To: <20070710180531.GB8908@osiris.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
	<20070710022213.81e7b432.akpm@linux-foundation.org>
	<20070710154503.GC27033@thunk.org>
	<20070710180531.GB8908@osiris.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 20:05:31 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> > Alternatively I can push them directly to Linus along with other ext4
> > patches.  We can drop the s390 patch if Martin or Heiko wants to wire
> > it up themselves.
> 
> Yes, please drop the s390 patch. In general it seems to be better if only
> one architecture gets a syscall wired up initially and let other arches
> follow later.

Yep.

otoh, fallocate() was special, because we had so many problems working out
how to organise the args so that certain kooky architectures can implement
it.

> Just wondering if the x86_64 compat syscall gets ever fixed? I think
> I mentioned already three or four times to Amit that it is broken.
> Or is it that nobody cares? Dunno..
> 
> In addition there used to be a somewhat inofficial rule that new syscalls
> have to come with a test program, so people can easily test if they wired
> up the syscall correctly.

Yes please.  I normally just slam the whole .c file into the changelog.

I'd support an ununofficial rule that submitters of new syscalls also raise
a patch against LTP, come to that...
