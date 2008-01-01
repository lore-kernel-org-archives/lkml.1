Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYAAPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYAAPSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYAAPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:17:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47925 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYAAPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:17:54 -0500
Date: Tue, 1 Jan 2008 16:19:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20080101151942.GA28085@one.firstfloor.org>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org> <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <20071225033418.GA29199@one.firstfloor.org> <20080101124741.GH11776@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101124741.GH11776@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, unfortunately, querying to find out how much memory is being
> used by which parts of the system is something which I think needs to
> be more than just a debugging feature.  One could argue that "vmstat",

slabinfo is about querying kernel internals and requiring stable
and permanent interfaces to that would imply freezing the kernel
internals.

People who want to have information about slabs and other similar
kernel internal allocations will always have to deal with version
dependencies.

No way around that.

> Perhaps /proc/slabinfo should be that relatively stable interface, if

That would require at least never changing any slab caches in any 
subsystem. Obviously not an option. 

-Andi
