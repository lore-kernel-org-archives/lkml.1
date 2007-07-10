Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbXGJTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbXGJTcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXGJTcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:32:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbXGJTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:32:16 -0400
Date: Tue, 10 Jul 2007 12:31:08 -0700
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
Message-Id: <20070710123108.e0f6e9b6.akpm@linux-foundation.org>
In-Reply-To: <20070710190735.GF27033@thunk.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710115251.GG2343@thunk.org>
	<20070710101558.cea7aab1.akpm@linux-foundation.org>
	<20070710190735.GF27033@thunk.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 15:07:35 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Jul 10, 2007 at 10:15:58AM -0700, Andrew Morton wrote:
> > So I dropped everything.  Let's start again from scratch.  I'd suggest that
> > for now we go with just an i386/x86_64 implementation, let the arch
> > maintainers wire things up when that has settled down.
> 
> Ok, so no objections if we push the i386/x86_64 implementation (only),
> plus the ext4 support to Linus?
> 

Sounds like a plan.

I haven't seriously looked at ext4 code in many months.  When I did I found
the changes to be quite incomprehensible, very, very poorly commented and
with quite a lot of odd-looking things about which I asked but got, iirc,
no useful reply.

Hopefully it got better.

Which patches are you proposing merging into 2.6.23?
