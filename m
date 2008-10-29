Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYJ2Pek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYJ2Pek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYJ2Peb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:34:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41290 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYJ2Peb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:34:31 -0400
Date: Wed, 29 Oct 2008 08:34:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dedekind@infradead.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       ericvh@gmail.com, mfasheh@suse.com
Subject: Re: How do I printk <type> correctly?
Message-Id: <20081029083403.5afac2c1.randy.dunlap@oracle.com>
In-Reply-To: <1225267204.4350.10.camel@sauron>
References: <20081023114133.GA30187@x200.localdomain>
	<20081028161136.c652b9fd.randy.dunlap@oracle.com>
	<1225267204.4350.10.camel@sauron>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 10:00:04 +0200 Artem Bityutskiy wrote:

> On Tue, 2008-10-28 at 16:11 -0700, Randy Dunlap wrote:
> > On Thu, 23 Oct 2008 15:41:33 +0400 Alexey Dobriyan wrote:
> > 
> > > If variable is of Type	use	printk format specifier.
> > > ---------------------------------------------------------
> > > 		int			%d or %x
> > > 		unsigned int		%u or %x
> > > 		long			%ld ot %lx
> > > 		unsigned long		%lu or %lx
> > > 		long long		%lld or %llx
> > > 		unsigned long long	%llu or %llx
> > > 		size_t			%zu or %zx
> > > 		ssize_t			%zd or %zx
> > > 
> > > Raw pointer value SHOULD be printed with %p.
> > > 
> > > u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> > > 
> > > 	printk("%llu", (unsigned long long)u64_var);
> > > 
> > > s64 SHOULD be printed with %lld/%llx, (long long):
> > > 
> > > 	printk("%lld", (long long)s64_var);
> > > 
> > > If type is dependent on config option (sector_t), use format specifier
> > > of biggest type and explicitly cast to it.
> > > 
> > > Reminder: sizeof() result is of type size_t.
> 
> Do we have this somewhere in Documentation? Would be nice to have it.

It's in the C standard, which we don't try to put into Documentation/ AFAIK.

section 6.5.3.4, The sizeof operator:

4 The value of the result is implementation-defined, and its type (an unsigned integer type)
is size_t, defined in <stddef.h> (and other headers).


---
~Randy
