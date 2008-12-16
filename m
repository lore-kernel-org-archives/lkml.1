Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYLPBUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYLPBUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYLPBUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:20:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbYLPBUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:20:37 -0500
Date: Mon, 15 Dec 2008 17:19:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com, mingo@elte.hu,
       acme@ghostprotocols.net
Subject: Re: Impact: (was Re: [PATCH] update rwlock initialization for
 nat_table)
Message-Id: <20081215171935.42a44d0d.akpm@linux-foundation.org>
In-Reply-To: <20081216011039.GA2458@x200.localdomain>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com>
	<49400B7F.7040607@cosmosbay.com>
	<alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com>
	<20081215.002019.232912990.davem@davemloft.net>
	<20081216011039.GA2458@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 04:10:39 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Dec 15, 2008 at 12:20:19AM -0800, David Miller wrote:
> > >     update rwlock initialization for nat_table
> > >     
> > >     Impact: clean up
> > >     
> > >     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
> > >     (netfilter: netns nat: per-netns NAT table) renamed the
> > >     nat_table from __nat_table to nat_table without updating the
> > >     __RW_LOCK_UNLOCKED(__nat_table.lock).
> > >     
> > >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > Applied to net-2.6, thanks Steven.
> > 
> > As Andrew mentioned this is a bug (albeit a "nano-bug" as you
> > called it :-) so I removed the Impact line in the commit
> > message when applying this.
> 
> Speaking of Impact: lines, is this a new fashion or what?
> 
> Looking at the ones which are already in official tree, they are either
> trivially duplicating Subject: line, or effectively duplicating Subject: line,
> or cover up for insufficiently informative (read: badly written) Subject: line,
> or simply useless.
> 
> 
> 	Subject: sched: CPU remove deadlock fix
> 	Impact: fix possible deadlock in CPU hot-remove path
> 
> What prevented to write "Subject: sched: fix possible deadlock in CPU hot-remove path"?
> 
> 
> 	AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0
> 	Impact: minor fix
> 
> Well...
> 
> I have an idea on how to make them remotely useful, but can we agree that there is
> a problem arising here?

heh, I must say that the ones I've seen haven't been very useful.


However...  Given the amount of time I (and others, to a lesser extent)
spend complaining about and scratching heads over crappy changelogs, we
would benefit from having a standard changelog template.

Something which guides people to creating a good changelog.  But it
would have to be short, and carefully written.  It should learn from
history, to wit:

- ./REPORTING-BUGS has a template and afaik it has never elicited any
  useful information.

- Documentation/SubmittingPatches has info on how to write a
  changelog, and people blithely ignore it.

- kerneldoc provide a template of sorts, and we see that filling out
  templates puts people's brains into "filling out a template" mode,
  rather than into "communicating information" mode.

An interesting problem.
