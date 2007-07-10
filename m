Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXGJSjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXGJSjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXGJSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:39:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34586 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXGJSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:39:08 -0400
Date: Wed, 11 Jul 2007 00:09:12 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070710183912.GB15345@amitarora.in.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org> <20070710154503.GC27033@thunk.org> <20070710180531.GB8908@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710180531.GB8908@osiris.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 08:05:31PM +0200, Heiko Carstens wrote:
> > Alternatively I can push them directly to Linus along with other ext4
> > patches.  We can drop the s390 patch if Martin or Heiko wants to wire
> > it up themselves.
> 
> Yes, please drop the s390 patch. In general it seems to be better if only
> one architecture gets a syscall wired up initially and let other arches
> follow later.
> 
> Just wondering if the x86_64 compat syscall gets ever fixed? I think
> I mentioned already three or four times to Amit that it is broken.
> Or is it that nobody cares? Dunno..

Last time it was brought up was when TAKE5 of the patchset was posted
and I had planned to fix this in the TAKE6 - which didn't happen since
there was no final descision on the mode flags.
Anyhow, the x86_64 compat syscall has already been fixed in the ext4
patch queue.
I will repost all the patches rebased on 2.6.22 (as they are in the
ext4 patch queue), since these have already been dropped from -mm.
 
> In addition there used to be a somewhat inofficial rule that new syscalls
> have to come with a test program, so people can easily test if they wired
> up the syscall correctly.

Ok. Will work on a small testcase and post it soon.

--
Regards,
Amit Arora
