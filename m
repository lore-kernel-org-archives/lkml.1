Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbYGBJp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbYGBJp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYGBJpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:45:52 -0400
Received: from ozlabs.org ([203.10.76.45]:49987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYGBJpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:45:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18539.20039.516803.51920@cargo.ozlabs.ibm.com>
Date: Wed, 2 Jul 2008 19:45:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
In-Reply-To: <20080702003755.4daff613.akpm@linux-foundation.org>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	<20080702003755.4daff613.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Those are dopey weasel words and they should be removed.

Thanks.  That is my opinion too.

> If we put stuff in sysfs then people WILL use it and we WILL need to
> support it for ever.  Pointing at some document and saying "call my
> lawyer" just won't cut it.
> 
> sysfs is part of the kernel ABI.  We should design our interfaces there
> as carefully as we design any others.
> 
> > They read that to mean that sysfs is not a suitable interface for them
> > to use to get information about the system.  In particular they read
> > that to mean that if they do code their library to read sysfs, it will
> > change in the future in such a way as to break their code.
> > 
> > In other words, they see sysfs as being completely useless for them
> > because they can't depend on it as a stable interface.  Which is
> > reasonable given the quoted paragraph, but on the other hand, I don't
> > believe we break userspace interfaces as blithely as that paragraph
> > suggests.
> 
> Well it's up to them - they own the files.  If they later change them
> and break their own interfaces (and presumably their own applications),
> well, perhaps they have chosen an inappropriate career?

We have too many "they"s, perhaps.  I meant that these developers (of
an HPC library that wants to know about cpu caches and topology) see
sysfs as being completely useless as a source of information because
they expect random kernel developers to keep changing it in
incompatible ways.  So "they" (library developers) don't own the files
- they're not kernel developers at all.

> > So which is it?  Can they rely on the CPU cache and topology
> > information under /sys/devices/system/cpu/cpu*, and rely on having
> > that information there essentially forever?  Or are they correct in
> > saying sysfs is useless and we need to find some other way to expose
> > the cache and topology information?
> 
> Use sysfs.  Choose a representation which is maitainable in a
> backward-compatible fashion for all time.  Maintain it.

Thanks. :)

Paul.
