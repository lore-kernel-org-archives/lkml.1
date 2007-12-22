Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXLVCnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXLVCnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXLVCnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:43:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41603 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVCnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:43:40 -0500
Date: Sat, 22 Dec 2007 03:44:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222024434.GB6062@one.firstfloor.org>
References: <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <1198289982.4411.2.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198289982.4411.2.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 08:19:42PM -0600, Matt Mackall wrote:
> 
> On Sat, 2007-12-22 at 01:28 +0100, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. slabtop 
> > > relies on it, people use it every day to monitor memory consumption.
> > 
> > It's definitely not a stable ABI. slabtop tends to exit without any
> > error message on any slabinfo version number increase and I've seen
> > that happen several times in not so old kernels.
> > 
> > Requiring just another slabtop update isn't really a big deal.
> 
> Might as well mention that SLOB also doesn't provide this functionality,
> nor would it make any sense for it to try (because there are no
> slab-like objects to report about).

% slabinfo
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
...
anon_vma                  1551      24    81.9K        20/18/2  128 0  90  45

Seems certainly like information that slabtop could report, even if it's
not exactly the same.

-Andi
