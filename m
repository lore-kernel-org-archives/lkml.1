Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXGJSFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXGJSFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbXGJSFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:05:37 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61181 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbXGJSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:05:36 -0400
Date: Tue, 10 Jul 2007 20:05:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070710180531.GB8908@osiris.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org> <20070710154503.GC27033@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710154503.GC27033@thunk.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Alternatively I can push them directly to Linus along with other ext4
> patches.  We can drop the s390 patch if Martin or Heiko wants to wire
> it up themselves.

Yes, please drop the s390 patch. In general it seems to be better if only
one architecture gets a syscall wired up initially and let other arches
follow later.

Just wondering if the x86_64 compat syscall gets ever fixed? I think
I mentioned already three or four times to Amit that it is broken.
Or is it that nobody cares? Dunno..

In addition there used to be a somewhat inofficial rule that new syscalls
have to come with a test program, so people can easily test if they wired
up the syscall correctly.
