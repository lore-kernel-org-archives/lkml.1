Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbXGJRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbXGJRSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbXGJRSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:18:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbXGJRSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:18:00 -0400
Date: Tue, 10 Jul 2007 10:15:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch (was:
 re: -mm merge plans for 2.6.23)
Message-Id: <20070710101558.cea7aab1.akpm@linux-foundation.org>
In-Reply-To: <20070710115251.GG2343@thunk.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710115251.GG2343@thunk.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 07:52:51 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> >  Merge
> > 
> > fallocate-implementation-on-i86-x86_64-and-powerpc.patch
> 
> Andrew,
> 
> Could you replace the comment/header section of
> fallocate-implementation-on-i86-x86_64-and-powerpc.patch with the
> following (attached below) ?  This is from the ext4 patches, where
> Amit had cleaned up description, which will make for a cleaner and
> easier to understand submission into the git tree.

There were issues with the x86 patch, the s390 patch was wrong and Tony
wants the the ia64 patch to use a different syscall number.

So I dropped everything.  Let's start again from scratch.  I'd suggest that
for now we go with just an i386/x86_64 implementation, let the arch
maintainers wire things up when that has settled down.
